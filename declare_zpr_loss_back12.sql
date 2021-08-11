
drop table #tt10
drop table #tt66

--исходные данные, группировка
select max([AGENT_NSI]) as [AGENT_NSI],
  max([AGENT_ID]) as [AGENT_ID], 
  max([AGENT_NAME]) as [AGENT_NAME], 
  convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01')) as [DATE], 
  sum([ZPR_SUM]) as [ZPR_SUM], 
  sum([LOSS_SUM]) as [LOSS_SUM]
 into #tt10
 from [Publisher].[dbo].[PRF_DBO_INS_CONTRACT]
 where ([CONTRACT_CHANNEL_GROUP_NAME] = 'Агенты ЦРС') 
  and ([CONTRACT_VID_NAME] like '%Осаго%')
  and ([CONTRACT_S_DATE] between '2019-01-01 00:00:00' and '2020-12-31 23:59:59')
 group by [AGENT_NSI], convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01'))
 order by [AGENT_NSI], convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01'))

 --скрипт для бектренда на 12 мес, сумма
 declare @t table ([AGENT_NSI] nvarchar(250), [AGENT_ID] nvarchar(250), [AGENT_NAME] nvarchar(250), [DATE] date, [ZPR_SUM] money, [LOSS_SUM] money);
insert into @t
select [AGENT_NSI], [AGENT_ID], [AGENT_NAME], [DATE], [ZPR_SUM], [LOSS_SUM] from #tt10 ;

 with s as
(
 select
  [AGENT_NSI], [DATE], [ZPR_SUM], [LOSS_SUM],
  sum([ZPR_SUM]) over (partition by [AGENT_NSI] order by [DATE] rows between 11 preceding and current row) as [ZPR_SUM_BACK_12M],
  sum([LOSS_SUM]) over (partition by [AGENT_NSI] order by [DATE] rows between 11 preceding and current row) as [LOSS_SUM_BACK_12M]
 from
  @t
)
select
 a.[AGENT_NSI], b.[DATE], s.[ZPR_SUM_BACK_12M], s.[LOSS_SUM_BACK_12M]
 into #tt66
from
 (select [AGENT_NSI], ('2020-01-01') from @t group by [AGENT_NSI]) a ([AGENT_NSI], date_min) cross apply
 (
  select
   dateadd(month, t.n, a.date_min)
  from
   (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11)) t(n)
 ) b([DATE]) left join
 s on s.[AGENT_NSI] = a.[AGENT_NSI] and s.[DATE] = b.[DATE]
 order by [AGENT_NSI], [DATE];

 select * from #tt66
 order by [AGENT_NSI], [DATE]
 
 
