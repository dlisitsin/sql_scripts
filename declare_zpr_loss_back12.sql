
drop table #tt10
drop table #tt66

--исходные данные, группировка
select max([CLIENT]) as [CLIENT],
  max([CLIENT_ID]) as [CLIENT_ID], 
  max([CLIENT_NAME]) as [CLIENT_NAME], 
  convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01')) as [DATE], 
  sum([ZPR_SUM]) as [ZPR_SUM], 
  sum([LOSS_SUM]) as [LOSS_SUM]
 into #tt10
 from TABLE 
 where ([CONTRACT_CHANNEL_GROUP_NAME] = 'Агенты ЦРС') 
  and ([CONTRACT_VID_NAME] like '%Product%')
  and ([CONTRACT_S_DATE] between '2019-01-01 00:00:00' and '2020-12-31 23:59:59')
 group by [CLIENT], convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01'))
 order by [CLIENT], convert(date, concat(datepart(year,[CONTRACT_S_DATE]), '-', datepart(month,[CONTRACT_S_DATE]), '-', '01'))

 --скрипт для бектренда на 12 мес, сумма
 declare @t table ([CLIENT] nvarchar(250), [CLIENT_ID] nvarchar(250), [CLIENT_NAME] nvarchar(250), [DATE] date, [ZPR_SUM] money, [LOSS_SUM] money);
insert into @t
select [CLIENT], [CLIENT_ID], [CLIENT_NAME], [DATE], [ZPR_SUM], [LOSS_SUM] from #tt10 ;

 with s as
(
 select
  [CLIENT], [DATE], [ZPR_SUM], [LOSS_SUM],
  sum([ZPR_SUM]) over (partition by [CLIENT] order by [DATE] rows between 11 preceding and current row) as [ZPR_SUM_BACK_12M],
  sum([LOSS_SUM]) over (partition by [CLIENT] order by [DATE] rows between 11 preceding and current row) as [LOSS_SUM_BACK_12M]
 from
  @t
)
select
 a.[CLIENT], b.[DATE], s.[ZPR_SUM_BACK_12M], s.[LOSS_SUM_BACK_12M]
 into #tt66
from
 (select [CLIENT], ('2020-01-01') from @t group by [CLIENT]) a ([CLIENT], date_min) cross apply
 (
  select
   dateadd(month, t.n, a.date_min)
  from
   (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11)) t(n)
 ) b([DATE]) left join
 s on s.[CLIENT] = a.[CLIENT] and s.[DATE] = b.[DATE]
 order by [CLIENT], [DATE];

 select * from #tt66
 order by [CLIENT], [DATE]
 
 
