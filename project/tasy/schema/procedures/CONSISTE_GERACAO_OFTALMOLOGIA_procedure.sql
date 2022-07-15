-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_geracao_oftalmologia ( nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



qt_oftalmo_permitida_w	bigint;
qt_oftalmo_gerada_w	bigint;


BEGIN
qt_oftalmo_permitida_w := obter_param_usuario(3010, 98, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p, qt_oftalmo_permitida_w);

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select count(*)
	into STRICT   qt_oftalmo_gerada_w
	from   oft_consulta
	where  nr_atendimento = nr_atendimento_p;

	if (qt_oftalmo_permitida_w > 0) and (qt_oftalmo_gerada_w >= qt_oftalmo_permitida_w) then
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(204621,'QT_OFTALMOLOGIA_GERADA='||qt_oftalmo_gerada_w);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_geracao_oftalmologia ( nr_atendimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

