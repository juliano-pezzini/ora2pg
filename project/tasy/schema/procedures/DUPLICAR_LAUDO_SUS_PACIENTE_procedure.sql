-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_laudo_sus_paciente ( nr_atendimento_p bigint, nr_seq_interno_p bigint, ie_gerar_novo_atend_p text, ie_finalizar_atend_p text, nm_usuario_p text, nr_seq_novo_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_seq_novo_w		bigint;
nr_atendimento_w	bigint;
ds_erro_w		varchar(255);


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	nr_atendimento_w := nr_atendimento_p;
	 
	if (ie_gerar_novo_atend_p = 'S') then 
		begin 
		nr_atendimento_w := duplicar_atendimento( 
			nr_atendimento_p, nm_usuario_p, nr_atendimento_w);
		end;
	end if;
	 
	nr_seq_novo_w := duplicar_sus_laudo_paciente( 
		nr_seq_interno_p, nr_atendimento_w, nm_usuario_p, nr_seq_novo_w);
 
	if (ie_finalizar_atend_p = 'S') then 
		begin 
		ds_erro_w := finalizar_atendimento( 
			nr_atendimento_p, 'S', nm_usuario_p, ds_erro_w);
		end;
	end if;
	end;
end if;
nr_seq_novo_p	:= nr_seq_novo_w;
ds_erro_p	:= ds_erro_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_laudo_sus_paciente ( nr_atendimento_p bigint, nr_seq_interno_p bigint, ie_gerar_novo_atend_p text, ie_finalizar_atend_p text, nm_usuario_p text, nr_seq_novo_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;

