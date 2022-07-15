-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_gerar_chamado ( nr_sequencia_p bigint, nr_seq_contrato_p bigint, ie_tipo_servico_p text, nm_usuario_p text, cd_procedencia_p bigint) AS $body$
DECLARE



cd_estabelecimento_w  eme_regulacao.cd_estabelecimento%type;
dt_chamado_w          eme_regulacao.dt_chamado%type;
cd_pessoa_fisica_w    eme_regulacao.cd_pessoa_fisica%type;
ds_endereco_w         eme_regulacao.ds_endereco%type;
ds_bairro_w           eme_regulacao.ds_bairro%type;
ds_municipio_w        eme_regulacao.ds_municipio%type;
sg_estado_w           eme_regulacao.sg_estado%type;
nr_fone_solic_w       eme_regulacao.nr_fone_solic%type;
nr_seq_origem_w       eme_reg_resposta.nr_seq_origem%type;
cd_cep_w              compl_pessoa_fisica.cd_cep%type;
dt_partida_w          eme_reg_resposta.dt_partida%type;
dt_chegada_base_w     eme_reg_resposta.dt_chegada_base%type;
nr_seq_unidade_w      eme_reg_resposta.nr_seq_unidade%type;
nr_seq_destino_w      eme_reg_resposta.nr_seq_destino%type;
dt_chegada_local_w    eme_reg_resposta.dt_chegada_local%type;
dt_saida_local_w      eme_reg_resposta.dt_saida_local%type;
ds_solicitante_w      eme_regulacao.ds_solicitante%type;
ds_observacao_w       eme_regulacao.ds_observacao%type;
nr_chamado_w          eme_chamado.nr_sequencia%type;
cd_medico_resp_w      eme_regulacao.cd_medico_resp%type;
nr_seq_resp_w         eme_regulacao.nr_seq_resposta%type;
ie_gerar_chamado_at_w eme_reg_resp.ie_gerar_chamado_at%type;
nr_rel_solic_pac_w    eme_regulacao.nr_rel_solic_pac%type;
ds_erro_w             varchar(2000) := '';
ie_somente_tecnico_w  varchar(1);
qt_existe_w           bigint;


BEGIN

ie_somente_tecnico_w := obter_param_usuario(989, 11, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_somente_tecnico_w);

select	cd_estabelecimento,
	dt_chamado,
	cd_pessoa_fisica,
	ds_solicitante,
	ds_endereco,
	ds_bairro,
	ds_municipio,
	sg_estado,
	nr_fone_solic,
	ds_observacao,
	cd_medico_resp,
	nr_seq_resposta,
	nr_rel_solic_pac
into STRICT	cd_estabelecimento_w,
	dt_chamado_w,
	cd_pessoa_fisica_w,
	ds_solicitante_w,
	ds_endereco_w,
	ds_bairro_w,
	ds_municipio_w,
	sg_estado_w,
	nr_fone_solic_w,
	ds_observacao_w,
	cd_medico_resp_w,
	nr_seq_resp_w,
	nr_rel_solic_pac_w
from	eme_regulacao
where	nr_sequencia = nr_sequencia_p;

select	count(*)
into STRICT	qt_existe_w
from	eme_reg_resposta
where	nr_seq_reg = nr_sequencia_p;

if (qt_existe_w > 0) then

	select	nr_seq_origem,
		dt_partida,
		dt_chegada_base,
		nr_seq_unidade,
		nr_seq_destino,
		dt_chegada_local,
		dt_saida_local
	into STRICT	nr_seq_origem_w,
		dt_partida_w,
		dt_chegada_base_w,
		nr_seq_unidade_w,
		nr_seq_destino_w,
		dt_chegada_local_w,
		dt_saida_local_w
	from	eme_reg_resposta
	where	nr_seq_reg = nr_sequencia_p;
else
	if (coalesce(ie_somente_tecnico_w,'N') = 'N') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(189980);
	end if;
end if;


select	coalesce(max(cd_cep),0)
into STRICT	cd_cep_w
from	compl_pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_w
and	ie_tipo_complemento = 1;

	
select	nextval('eme_chamado_seq')
into STRICT	nr_chamado_w
;

insert into eme_chamado(
		nr_sequencia,
		nr_seq_contrato,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		dt_chamado,
		ie_remocao_aerea,
		cd_pessoa_fisica,
		nr_seq_origem,
		ds_contato,
		ds_endereco,
		ds_bairro,
		ds_municipio,
		sg_estado,
		cd_cep,
		ds_fone_contato,
		ie_tipo_servico,
		ds_observacao,
		dt_saida,
		dt_retorno,
		nr_seq_veiculo,
		nr_seq_destino,
		dt_inicio_atend,
		dt_fim_atend,
		cd_medico_resp,
		cd_procedencia,
		nr_rel_solic_pac,
		nr_seq_regulacao,
		ie_faturamento,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
values (	nr_chamado_w,
		nr_seq_contrato_p,
		cd_estabelecimento_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		'N',
		cd_pessoa_fisica_w,
		nr_seq_origem_w,
		ds_solicitante_w,
		ds_endereco_w,
		ds_bairro_w,
		ds_municipio_w,
		sg_estado_w,
		cd_cep_w,
		nr_fone_solic_w,
		ie_tipo_servico_p,
		ds_observacao_w,
		dt_partida_w,
		dt_chegada_base_w,
		nr_seq_unidade_w,
		nr_seq_destino_w,
		dt_chegada_local_w,
		dt_saida_local_w,
		cd_medico_resp_w,
		cd_procedencia_p,
		nr_rel_solic_pac_w,
		nr_sequencia_p,
		'S',
		clock_timestamp(),
		nm_usuario_p);

CALL gerar_eme_proced_chamado(nr_seq_contrato_p, nr_chamado_w, nm_usuario_p);
		
if (coalesce(nr_seq_resp_w,0) > 0) then
	begin
	select	ie_gerar_chamado_at
	into STRICT	ie_gerar_chamado_at_w
	from	eme_reg_resp
	where	nr_sequencia =  nr_seq_resp_w;

	if (ie_gerar_chamado_at_w = 'S')then
		ds_erro_w := Eme_consiste_gerar_atendimento(nr_chamado_w, ds_erro_w);
		if (coalesce(ds_erro_w::text, '') = '') then
			CALL Gerar_eme_atendimento(nr_chamado_w, nm_usuario_p);
		else
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(189984, 'DS_ERRO='||ds_erro_w);
		end if;
	end if;
	end;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_gerar_chamado ( nr_sequencia_p bigint, nr_seq_contrato_p bigint, ie_tipo_servico_p text, nm_usuario_p text, cd_procedencia_p bigint) FROM PUBLIC;

