-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE codificacao_assumir_pendencia ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_grupo_atual_w		codificacao_grupo.nr_sequencia%type;


BEGIN

select	max(a.nr_sequencia)
into STRICT	cd_grupo_atual_w
from	codificacao_grupo a,
		codificacao_grupo_perfil b
where	a.nr_sequencia 	= b.nr_seq_grupo
and		coalesce(b.cd_perfil,0)	= obter_perfil_ativo;


if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (cd_grupo_atual_w IS NOT NULL AND cd_grupo_atual_w::text <> '') then

		update	codificacao_atendimento
		set		ie_status 				= 'PA',
				nm_responsavel 			= CASE WHEN nm_responsavel = NULL THEN  nm_usuario_p  ELSE nm_responsavel END ,
				nm_responsavel_atual 	= nm_usuario_p,
				cd_grupo_atual 			= cd_grupo_atual_w,
				dt_atualizacao 			= clock_timestamp(),
				nm_usuario 				= nm_usuario_p
		where	nr_sequencia 			= nr_sequencia_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE codificacao_assumir_pendencia ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

