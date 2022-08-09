-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_eme_regulacao ( cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, cd_usuario_conv_p text, cd_medico_regulador_p text, nr_seq_tipo_servico_p bigint, nr_seq_unidade_p bigint, nr_atendimento_novo_p INOUT text, nr_atendimento_p bigint, ie_gerar_atendimento_p text, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_novo_w	varchar(10);

BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
 
	 
		update	eme_regulacao 
		set		dt_liberacao_tecnico	= clock_timestamp(), 
				nm_usuario    	= nm_usuario_p, 
				dt_atualizacao		= clock_timestamp() 
    where	nr_sequencia = nr_sequencia_p;
	 
	if (ie_gerar_atendimento_p = 'S') then 
		begin 
		nr_atendimento_novo_w := gerar_atendimento_regulacao( 
			nr_sequencia_p, cd_pessoa_fisica_p, cd_estabelecimento_p, cd_usuario_conv_p, cd_medico_regulador_p, nr_seq_tipo_servico_p, nr_seq_unidade_p, nm_usuario_p, nr_atendimento_novo_w);
		end;
	end if;	
 
	if ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') or 
		(nr_atendimento_novo_w IS NOT NULL AND nr_atendimento_novo_w::text <> '')) then 
		begin 
		CALL gerar_propaci_regulacao( 
			nr_sequencia_p, 
			nm_usuario_p);
		end;
	end if;
	end;
end if;
nr_atendimento_novo_p := nr_atendimento_novo_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_eme_regulacao ( cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, cd_usuario_conv_p text, cd_medico_regulador_p text, nr_seq_tipo_servico_p bigint, nr_seq_unidade_p bigint, nr_atendimento_novo_p INOUT text, nr_atendimento_p bigint, ie_gerar_atendimento_p text, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
