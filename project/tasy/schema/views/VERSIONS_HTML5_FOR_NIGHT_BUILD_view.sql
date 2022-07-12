-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW versions_html5_for_night_build (ds_branch, dt_atualizacao, cd_tasy_version, hotfix, dt_agendamento) AS select distinct co.ds_branch, max(dt_atualizacao) dt_atualizacao, substr(co.ds_branch,1,9) cd_tasy_version
			    , substr(co.ds_branch,10,length(co.ds_branch)-1) hotfix
				, trunc(LOCALTIMESTAMP + interval '1 days')-1/3.9 dt_agendamento
FROM man_commit_git co
where co.dt_atualizacao >= (trunc(LOCALTIMESTAMP)-1/4)
and NOT UPPER(co.ds_projeto) in ('TASY-PLSQL-OBJECTS')
AND NOT UPPER(co.DS_BRANCH) IN ('DEV')
and not exists (select 1
                  from tasy_queue_build
                 where ie_aplicacao in ('F','B') 
                   and ie_status_build in ('G','A') 
                   and trunc(dt_atualizacao) = trunc(LOCALTIMESTAMP)
                   and dt_atualizacao >= co.dt_atualizacao
                   and (cd_versao = substr(co.ds_branch,1,9) or (cd_versao = substr(co.ds_branch,1,9) 
                   and branch_name = substr(co.ds_branch,10,length(co.ds_branch)-1))))
group by co.ds_branch
order by 4, 3;

