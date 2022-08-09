-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_dados_usuario (nm_usuario_dest_p text, nm_usuario_orig_p text, nm_usuario_p text) AS $body$
DECLARE



cd_setor_atendimento_w	varchar(10) := '';
ie_tipo_evolucao_w	varchar(10) := '';
ie_profissional_w	varchar(10) := '';
cd_estabelecimento_w	varchar(10) := '';


BEGIN

select 	max(cd_setor_atendimento),
	max(ie_tipo_evolucao),
	max(ie_profissional),
	max(cd_estabelecimento)
into STRICT	cd_setor_atendimento_w,
	ie_tipo_evolucao_w,
	ie_profissional_W,
	cd_estabelecimento_w
from	usuario
where	nm_usuario = nm_usuario_orig_p;

update 	usuario
set	cd_setor_atendimento = cd_Setor_atendimento_W,
	ie_tipo_evolucao = ie_tipo_evolucao_w,
	ie_profissional = ie_profissional_w,
	cd_estabelecimento = cd_estabelecimento_w
where	nm_usuario = nm_usuario_dest_p;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_dados_usuario (nm_usuario_dest_p text, nm_usuario_orig_p text, nm_usuario_p text) FROM PUBLIC;
