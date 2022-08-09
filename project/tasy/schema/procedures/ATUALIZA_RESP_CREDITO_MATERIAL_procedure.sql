-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_resp_credito_material ( nr_sequencia_p bigint, ie_responsavel_credito_p text, nm_usuario_p text) AS $body$
DECLARE


ie_valor_informado_w	varchar(1) := 'N';


BEGIN

select	coalesce(max(obter_valor_param_usuario(67, 112, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento)), 'N')
into STRICT	ie_valor_informado_w
;

update	material_atend_paciente
set	ie_responsavel_credito = ie_responsavel_credito_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp(),
	ie_valor_informado = ie_valor_informado_w
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_resp_credito_material ( nr_sequencia_p bigint, ie_responsavel_credito_p text, nm_usuario_p text) FROM PUBLIC;
