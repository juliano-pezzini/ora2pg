-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_sequencia_cheque_cpa ( cd_conta_p bigint, nr_cheque_p text) AS $body$
DECLARE


ie_obter_nr_cheque	varchar(1);
ie_gerar_nr_cheque	varchar(1);


BEGIN

ie_obter_nr_cheque := obter_param_usuario(127, 36, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_obter_nr_cheque);
ie_gerar_nr_cheque := obter_param_usuario(127, 42, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_gerar_nr_cheque);

if ((coalesce(ie_obter_nr_cheque,'N') = 'S') and (coalesce(ie_gerar_nr_cheque,'N') = 'S')) then

	if (nr_cheque_p IS NOT NULL AND nr_cheque_p::text <> '') then
		update	banco_estabelecimento
		set		nr_ultimo_cheque = nr_cheque_p
		where	nr_sequencia = cd_conta_p;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_sequencia_cheque_cpa ( cd_conta_p bigint, nr_cheque_p text) FROM PUBLIC;
