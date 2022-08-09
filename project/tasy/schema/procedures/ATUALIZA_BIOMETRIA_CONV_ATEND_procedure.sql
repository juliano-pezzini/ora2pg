-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_biometria_conv_atend ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nr_biometria_conv_p bigint, nr_seq_just_biometria_conv_p bigint, nm_usuario_p text) AS $body$
DECLARE

ds_erro_w		varchar(255);


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') and (nr_biometria_conv_p IS NOT NULL AND nr_biometria_conv_p::text <> '') and (nr_seq_just_biometria_conv_p IS NOT NULL AND nr_seq_just_biometria_conv_p::text <> '') then
	begin

	update	atend_categoria_convenio
	set		NR_BIOMETRIA_CONV 			= nr_biometria_conv_p,
			NR_SEQ_JUST_BIOMETRIA_CONV	= nr_seq_just_biometria_conv_p
	where	nr_seq_interno = nr_seq_interno_p
	and		nr_atendimento = nr_atendimento_p;

	exception
	when others then
		ds_erro_w	:= substr(sqlerrm,1,255);
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_biometria_conv_atend ( nr_atendimento_p bigint, nr_seq_interno_p bigint, nr_biometria_conv_p bigint, nr_seq_just_biometria_conv_p bigint, nm_usuario_p text) FROM PUBLIC;
