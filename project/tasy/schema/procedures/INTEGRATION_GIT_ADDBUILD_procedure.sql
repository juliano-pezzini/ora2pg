-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integration_git_addbuild ( NM_USUARIO_P text, NR_SEQ_ORDEM_SERV_P bigint, DS_BRANCH_P text, DS_PULL_REQUEST_p text) AS $body$
DECLARE

									
NR_SEQ_MAN_OS_CTRL_DESC_w	bigint;
NR_SEQ_MAN_OS_CTRL_BUILD_W	bigint;
DS_HOTFIX_W					varchar(25);
CD_VERSAO_w					varchar(15);									


BEGIN

select	nextval('man_os_ctrl_desc_seq')
into STRICT	NR_SEQ_MAN_OS_CTRL_DESC_w
;

insert into MAN_OS_CTRL_DESC(NR_SEQUENCIA,
							DT_ATUALIZACAO,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							NR_SEQ_ORDEM_SERV,
							DS_ALTERACAO,
							DT_LIBERACAO,
							NM_USUARIO_LIB,
							IE_APLICACAO)
				values (NR_SEQ_MAN_OS_CTRL_DESC_w,
						clock_timestamp(),
						NM_USUARIO_p,
						clock_timestamp(),
						NM_USUARIO_p,
						NR_SEQ_ORDEM_SERV_P,
						'Integration GIT',
						null,
						null,
						'H');

CD_VERSAO_W:= substr(ds_branch_p,1,9);
DS_HOTFIX_W:= substr(ds_branch_p,11,20);
						
select	nextval('man_os_ctrl_build_seq')
into STRICT	NR_SEQ_MAN_OS_CTRL_BUILD_W
;						
												
insert into MAN_OS_CTRL_BUILD( NR_SEQUENCIA,
							NR_SEQ_MAN_OS_CTRL_DESC,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							DT_ATUALIZACAO,
							CD_VERSAO,
							IE_SITUACAO,
							DS_PULL_REQUEST,
							DS_HOTFIX)
					values (NR_SEQ_MAN_OS_CTRL_BUILD_W,
							NR_SEQ_MAN_OS_CTRL_DESC_w,
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							CD_VERSAO_W,
							'A',
							DS_PULL_REQUEST_p,
							DS_HOTFIX_W);

insert into MAN_OS_CTRL_BUILD_ALT(NR_SEQUENCIA,
								NR_SEQ_MAN_OS_CTRL_BUILD,
								DT_ATUALIZACAO,
								NM_USUARIO,
								DT_ATUALIZACAO_NREC,
								NM_USUARIO_NREC,
								CD_PESSOA_FISICA,
								DS_PROJETO,
								DS_CLASSE,
								DS_ALTERACAO,
								CD_RAMAL,
								IE_CAMADA)
						values (nextval('man_os_ctrl_build_alt_seq'),
								NR_SEQ_MAN_OS_CTRL_BUILD_W,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								obter_pf_usuario(nm_usuario_p,'C'),
								'HTML5',
								'HTML5',
								'HTML5',
								000,
								'F');
								
					
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integration_git_addbuild ( NM_USUARIO_P text, NR_SEQ_ORDEM_SERV_P bigint, DS_BRANCH_P text, DS_PULL_REQUEST_p text) FROM PUBLIC;
