-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_internar_paciente ( nr_seq_regulacao_p bigint, nr_atendimento_p bigint, cd_medico_resp_p text, nm_usuario_p text) AS $body$
DECLARE


ds_comando_w		varchar(2000);
ds_sep_bv_w		varchar(50);
ie_status_regulacao_w	varchar(1);
cd_cnes_solicitante_w	varchar(10);
cd_cnes_executante_w	varchar(10);
cd_cnes_estab_w		varchar(10);


BEGIN

select	coalesce(max(cd_cnes_solicitante), '0'),
	coalesce(max(cd_cnes_executante), '0')
into STRICT	cd_cnes_solicitante_w,
	cd_cnes_executante_w
from	regulacao_atendimento
where	nr_sequencia	= nr_seq_regulacao_p;

cd_cnes_estab_w := substr(obter_cnes_estab(coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1)), 1, 10);


update	regulacao_atendimento
set	nr_atendimento	= nr_atendimento_p,
	nm_usuario	= nm_usuario_p,
	ie_status_regulacao	= '7'
where	nr_sequencia	= nr_seq_regulacao_p;

if	((coalesce(nr_seq_regulacao_p,0) > 0) and (coalesce(nr_atendimento_p,0) > 0)) then

	if (cd_cnes_solicitante_w <> cd_cnes_executante_w) then
		if (cd_cnes_estab_w = cd_cnes_executante_w) then
			CALL gravar_integracao_regulacao(477, 'nr_sequencia='||coalesce(nr_seq_regulacao_p, 0)||';');
		end if;
	else
		CALL gravar_integracao_regulacao(476, 'nr_sequencia='||coalesce(nr_seq_regulacao_p, 0)||';'||
						 'cd_pessoa_fisica_medico=' || cd_medico_resp_p||';');
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_internar_paciente ( nr_seq_regulacao_p bigint, nr_atendimento_p bigint, cd_medico_resp_p text, nm_usuario_p text) FROM PUBLIC;
