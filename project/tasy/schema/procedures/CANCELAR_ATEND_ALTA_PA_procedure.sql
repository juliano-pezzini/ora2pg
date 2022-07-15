-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_atend_alta_pa ( nr_atendimento_p bigint, nr_seq_motivo_p bigint, cd_pessoa_fisica_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE



nr_atend_alta_w		bigint;
ds_erro_w		varchar(255);
ie_cancelar_atend_w	varchar(10)	:= 'N';
ie_tipo_atendimento_w	bigint;


BEGIN
ie_cancelar_atend_w:= obter_valor_param_usuario(935,89,Obter_perfil_ativo,nm_usuario_p,0);
if (ie_cancelar_atend_w	= 'S') then
	begin
	select	max(nr_atendimento),
		max(ie_tipo_atendimento)
	into STRICT	nr_atend_alta_w,
		ie_tipo_atendimento_w
	from	atendimento_paciente
	where	nr_atend_alta	= nr_atendimento_p;
	RAISE NOTICE 'nr_atend_alta_w = %', nr_atend_alta_w;
	RAISE NOTICE 'ie_tipo_atendimento_w = %', ie_tipo_atendimento_w;
	if (nr_atend_alta_w IS NOT NULL AND nr_atend_alta_w::text <> '') and (ie_tipo_atendimento_w	= 3) then

		begin
		CALL cancelar_Atendimento_paciente(	nr_atend_alta_w,
						nm_usuario_p,
						nr_seq_motivo_p,
						cd_pessoa_fisica_p,
						ds_observacao_p);
		exception
			when others then
			ds_erro_w	:= sqlerrm;
			RAISE NOTICE 'ds_erro_w = %', ds_erro_w;

		end;
	end if;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_atend_alta_pa ( nr_atendimento_p bigint, nr_seq_motivo_p bigint, cd_pessoa_fisica_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

