-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_proced_hemocomp ( nr_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_solic_bco_p bigint, cd_estabelecimento_p bigint, ie_pasta_p text, ie_irradiado_p text, ie_lavado_p text, ie_filtrado_p text, ie_aliquotado_p text, nm_usuario_p text, cd_convenio_p INOUT bigint, cd_setor_p INOUT bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, nr_seq_proc_interno_p INOUT bigint ) AS $body$
DECLARE


-- ie_pasta_p ( H- Hemocomponente  e S - Solic Testes )
ie_derivado_exame_w 	bigint;
ds_erro_w		varchar(510);
ie_tipo_atend_w		smallint;
ie_tipo_convenio_w	smallint;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_setor_w		integer;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_proc_interno_w	bigint;
ie_nova_consiste_w	varchar(1);



BEGIN

if ( 'H' = ie_pasta_p) then
	ie_derivado_exame_w 	:= 0;
	ie_nova_consiste_w := obter_valor_param_usuario(924, 574, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
	if ( ie_nova_consiste_w = 'N') then
	begin
		-- Consiste_solic_hemocomponente
		ds_erro_w := Consiste_solic_hemocomponente(nr_seq_solic_bco_p, nr_sequencia_p, cd_estabelecimento_p, nm_usuario_p, ds_erro_w);
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			-- #@DS_ERRO#@
			CALL Wheb_mensagem_pck.exibir_mensagem_abort( 193870 , 'DS_ERRO=' || ds_erro_w );
		end if;
	end;
	end if;
elsif ('S' = ie_pasta_p) then
	ie_derivado_exame_w 	:= 1;
end if;

cd_convenio_w		:= obter_convenio_atendimento(nr_atendimento_p);
ie_tipo_atend_w		:= obter_tipo_atendimento(nr_atendimento_p);
ie_tipo_convenio_w	:= obter_tipo_convenio(cd_convenio_w);
cd_categoria_w		:= obter_categoria_atendimento(nr_atendimento_p);

cd_setor_w:= cd_setor_p;

SELECT * FROM Obter_Proced_sangue(ie_derivado_exame_w, nr_sequencia_p, cd_estabelecimento_p, ie_tipo_atend_w, ie_tipo_convenio_w, cd_convenio_w, cd_categoria_w, cd_setor_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w, ie_irradiado_p, ie_lavado_p, ie_filtrado_p, ie_aliquotado_p) INTO STRICT cd_setor_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_proc_interno_w;

cd_convenio_p		:= cd_convenio_w;
cd_setor_p		:= cd_setor_w;
cd_procedimento_p 	:= cd_procedimento_w;
ie_origem_proced_p	:= ie_origem_proced_w;
nr_seq_proc_interno_p	:= nr_seq_proc_interno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_proced_hemocomp ( nr_atendimento_p bigint, nr_sequencia_p bigint, nr_seq_solic_bco_p bigint, cd_estabelecimento_p bigint, ie_pasta_p text, ie_irradiado_p text, ie_lavado_p text, ie_filtrado_p text, ie_aliquotado_p text, nm_usuario_p text, cd_convenio_p INOUT bigint, cd_setor_p INOUT bigint, cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, nr_seq_proc_interno_p INOUT bigint ) FROM PUBLIC;

