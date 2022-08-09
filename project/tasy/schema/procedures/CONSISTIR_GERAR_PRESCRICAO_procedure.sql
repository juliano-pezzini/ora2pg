-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_gerar_prescricao ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_agrup_quimio_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE


ie_permite_sem_via_acesso_w	varchar(1);
ie_permite_sem_aplicacao_w	varchar(1);
ds_itens_inconsistentes_w	varchar(2000);


BEGIN

/* Quimioterapia - Parâmetro [68] - Permite gerar prescrição sem via de acesso caso a via de administração possua o respectivo vinculo no cadastro */

ie_permite_sem_via_acesso_w := obter_param_usuario(3130, 68, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_sem_via_acesso_w);

if (ie_permite_sem_via_acesso_w = 'N') then
	begin
	ds_itens_inconsistentes_w := consistir_via_acesso_pac_atend(nr_seq_atendimento_p, ds_itens_inconsistentes_w);

	if (ds_itens_inconsistentes_w IS NOT NULL AND ds_itens_inconsistentes_w::text <> '') then
		ds_erro_p	:= substr(obter_texto_tasy(59288, wheb_usuario_pck.get_nr_seq_idioma),1,255) || ds_itens_inconsistentes_w;
	end if;
	end;
end if;

/* Quimioterapia - Parâmetro [124] - Ao gerar a prescrição, consiste se a via de administração do medicamentos foram informados */

ie_permite_sem_aplicacao_w := obter_param_usuario(3130, 124, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_sem_aplicacao_w);

if (ie_permite_sem_aplicacao_w = 'S') then
	begin
	ds_itens_inconsistentes_w := consistir_via_aplic_pac_atend(nr_seq_atendimento_p, ds_itens_inconsistentes_w);

	if (ds_itens_inconsistentes_w IS NOT NULL AND ds_itens_inconsistentes_w::text <> '') then
		ds_erro_p	:= substr(obter_texto_tasy(59288, wheb_usuario_pck.get_nr_seq_idioma),1,255) || ds_itens_inconsistentes_w;
	end if;
	end;
end if;

select	consistir_se_agrup_quimio(nr_seq_paciente_p, nr_seq_atendimento_p, null, null)
into STRICT	ie_agrup_quimio_p
;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_gerar_prescricao ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_agrup_quimio_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;
