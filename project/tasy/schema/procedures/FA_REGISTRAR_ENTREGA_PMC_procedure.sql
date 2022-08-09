-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_registrar_entrega_pmc ( nr_seq_paciente_pmc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_paciente_entrega_p INOUT bigint ) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(14);
nr_paciente_entrega_w	bigint;
ds_param_w		varchar(10);
ds_senha_PNC_w		varchar(10);
ie_tipo_entrega_w	varchar(3);
ds_senha_w		varchar(10);


BEGIN
if (nr_seq_paciente_pmc_p IS NOT NULL AND nr_seq_paciente_pmc_p::text <> '') then
	ds_param_w :=	substr(Obter_Valor_Param_Usuario(10015, 56, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),1,10);
	ds_senha_PNC_w := substr(Obter_Valor_Param_Usuario(10015, 90, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),1,10);

	ie_tipo_entrega_w := substr(fa_obter_tipo_entrega_pac(nr_seq_paciente_pmc_p),1,3);

	if (ie_tipo_entrega_w = 'PNC') then
		ds_senha_w := ds_senha_PNC_w;
	else
		ds_senha_w := ds_param_w;
	end if;
	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from	fa_paciente_pmc
	where	nr_sequencia	 = nr_seq_paciente_pmc_p;

	select 	nextval('fa_paciente_entrega_seq')
	into STRICT	nr_paciente_entrega_w
	;

	insert into fa_paciente_entrega(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_pessoa_fisica,
		dt_entrada,
		ie_status_paciente,
		nr_seq_paciente_pmc,
		ds_senha,
		cd_estabelecimento)
	values (nr_paciente_entrega_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_pessoa_fisica_w,
		clock_timestamp(),
		'TR',
		nr_seq_paciente_pmc_p,
		ds_senha_w,
		cd_estabelecimento_p);
end if;

nr_paciente_entrega_p := nr_paciente_entrega_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_registrar_entrega_pmc ( nr_seq_paciente_pmc_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_paciente_entrega_p INOUT bigint ) FROM PUBLIC;
