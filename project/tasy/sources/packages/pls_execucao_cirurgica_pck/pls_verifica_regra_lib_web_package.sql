-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_execucao_cirurgica_pck.pls_verifica_regra_lib_web ( cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_usuario_web_p pls_usuario_web.nr_sequencia%type, ds_retorno_p INOUT text, nr_seq_regra_p INOUT bigint) AS $body$
DECLARE

			
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade  Validar se existe regra para liberacao de biometria para o profissicao e/ou usuario web. 
Retorna S se houver liberacao.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/			
nr_seq_regra_lib_bio_exec_w	pls_regra_lib_bio_exec.nr_sequencia%type;
ds_retorno_w			varchar(5) 	:= 'N';


BEGIN

select 	max(nr_sequencia)
into STRICT	nr_seq_regra_lib_bio_exec_w
from	pls_regra_lib_bio_exec
where 	ie_situacao			= 'A'
and	((coalesce(cd_medico::text, '') = '')	or (cd_medico		= cd_medico_p))
and	((coalesce(nr_seq_usuario_web::text, '') = '')	or (nr_seq_usuario_web	= nr_seq_usuario_web_p))
and	clock_timestamp() between dt_inicio_vigencia and coalesce(dt_fim_vigencia, clock_timestamp());

if (coalesce(nr_seq_regra_lib_bio_exec_w,0) > 0)then
	nr_seq_regra_p	:= nr_seq_regra_lib_bio_exec_w;
	ds_retorno_w	:= 'S';
end if;

ds_retorno_p	:= ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_execucao_cirurgica_pck.pls_verifica_regra_lib_web ( cd_medico_p pessoa_fisica.cd_pessoa_fisica%type, nr_seq_usuario_web_p pls_usuario_web.nr_sequencia%type, ds_retorno_p INOUT text, nr_seq_regra_p INOUT bigint) FROM PUBLIC;
