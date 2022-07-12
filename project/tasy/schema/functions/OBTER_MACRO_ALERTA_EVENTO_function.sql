-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macro_alerta_evento () RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);

BEGIN

ds_retorno_w	:=  substr(obter_desc_expressao(649422)/*'@paciente = Nome do paciente'||chr(13)||
						'@nascimento = Dt de nascimento'||chr(13)||
						'@pac_abreviado = Nome do paciente abreviado'||chr(13)||
						'@quarto = Unidade básica + compl'||chr(13)||
						'@setor = Setor atendimento'||chr(13)||
						'@atendimento = Nº atendimento'||chr(13)||
						'@ds_convenio = Descrição Convênio'||chr(13)||
						'@ramal = Nº ramal unidade'||chr(13)||
						'@telefone = Nº telefone setor'||chr(13)||
						'@agenda = Descrição da agenda'||chr(13)||
						'@dtinicioagenda = Hora de inicio da agenda'||chr(13)||
						'@procagenda = Procedimento da agenda'||chr(13)||
						'@dtcancelagenda = Dt de cancelamento da agenda'||chr(13)||
						'@dt_agendamento = Dt da agenda inicial'||chr(13)||
						'@medicoagenda = Médico do agendamento' || chr(13) ||
						'@data_atual = Dt atual sem horario)' || chr(13) ||
						'@data_hora_atual= Dt atual (com horario)' || chr(13) ||
						'@cd_cid= Código do CID' || chr(13) ||
						'@ds_cid= Descrição do CID' || chr(13) ||
						'@ie_setor_ant_pa= Define se o setor anterior é de PA' || chr(13) ||
						'@opme= Opme da agenda' || chr(13) ||
						'@qtopme= Quantidade do Opme da agenda' || chr(13) ||
						'@autorizacaoopme= Status da autorização do opme' || chr(13) ||
						'@listaopme= Listagem das opme''s da agenda'|| chr(13) ||
						'@fornec_opme= Fornecedor da OPME'|| chr(13) ||
						'@dt_transferencia= Dt da transferência do agendamento' || chr(13) ||
						'@agedestino= Agenda para qual o agendamento foi transferido' || chr(13) ||
						'@equipsolicitado= Equip solicitado para o empréstimo' || chr(13) ||
						'@estabeequipsolicitado= Estab do equipamento solicitado para o empréstimo' || chr(13) ||
						'@estabeequipsolicitante= Estab solicitante que realizou o empréstimo do equipamento' || chr(13) ||
						'@estabelecimentocme= Estabelecimento do cme' || chr(13) ||
						'@procadicagenda= Proced adicionais da agenda' || chr(13) ||
						'@reserva= Número da reserva do agendamento' || chr(13) ||
						'@cmesolicitado= CME solicitado para o empréstimo'|| chr(13) ||
						'@obs_classif_pessoa=Observação da classificação da PF'|| chr(13) ||
						'@tipo_atendimento = Tipo de atendimento' || chr(13) ||
						'@convenio = Convênio do atendimento' || chr(13) ||
						'@plano = Plano do convênio do atendimento' || chr(13) ||
						'@categoria = Categoria do convênio do atendimento' || chr(13) ||
						'@classif_pf = Classificações da pessoa física' || chr(13) ||
						'@motivo_cancel = Motivo cancelamento' || chr(13) ||
						'@obsagendamento = Observação do agendamento' || chr(13) ||
						'@usuarioramal = Ramal do usuário' || chr(13) ||
						'@nomeusuario = Nome do usuário ' || chr(13) ||
						'@dtorigemtransf = Dt origem do agendamento ' || chr(13) ||
						'@convenio	= Convênio' || chr(13) ||
						'@ds_setor_ant	= Setor anterior'  || chr(13) ||
						'@ds_setor_n_ant_pass  = Último setor não sendo passagem de setor'   || chr(13) ||
						'@cd_unid_basica_compl_ant = Unidade anterior' || chr(13) ||
						'@dt_baixa_tit_pagar = Dt de baixa do título' || chr(13) ||
						'@statusagenda = Status da agenda cirúrgica' || chr(13) ||
						'@obs_alta = Observação da alta' || chr(13) ||
						'@vl_baixa_tit_pagar = Valor de baixa do título' || chr(13) ||
						'@set_unidade = Setor da unidade do serviço de leito'|| chr(13) ||
						'@descpontosmust = Descrição pontos Escala Must' || chr(13) ||
						'@pontosmust  = Pontuação Escala Must'|| chr(13) ||
						'@Estagio_Mat_Espec = Estágio da autorização de materiais especiais'|| chr(13) ||
						'@ds_exame_autor   = Cód. e desc. dos exames autorizados' || chr(13) ||
						'@inicio_vigencia_autor = Início vigência da autorização convênio ' || chr(13) ||
						'@sequencia_autor = Nº seq da autorização convênio ' || chr(13) ||
						'@ds_estagio_autor = Descrição do estágio da autorização convênio ' || chr(13) ||
						'@nr_atend_autor = Nº do atendimento da autorização convênio ' || chr(13) ||
						'@tipo_guia_autor = Tipo guia da autorização convênio ' || chr(13) ||
						'@senha_autor =Senha da autorização convênio ' || chr(13) ||
						'@conteudo_mat_autor = Cód, descrição,qtde solic,qtde autorizada,forncedor do material na autorização ' || chr(13) ||
						'@fim_vigencia_autor = Fim vigência da autorização convênio '|| chr(13) ||
						'@pontos_mst = Pontuação escala MST'|| chr(13) ||
						'@desc_mst = Descrição pontuação escala MST'|| chr(13) ||
						'@dt_prevista = Dt prevista na "Gestão de Vagas"'|| chr(13) ||
						'@dt_alta_prevista = Dt alta prevista' || chr(13) ||
						'@pac_biobanco = Pac. Biobanco' || chr(13) ||
						'@prescricao = Nº da prescrição' || chr(13) ||
						'@exame = Descrição do exame laboratorial' || chr(13) ||
						'@dt_aprovacao = dt de aprovação do resultado' || chr(13) ||
						'@result_inaceitavel = Resultado do exame laboratorial(Valor inaceitável)' || chr(13) ||
						'@usuario_liberador = Pessoa que liberou/Aprovou o resultado do exame laboratorial' || chr(13) ||
						'@result_anterior_inac = Resultado anterior ao valor inaceitável' || chr(13) ||
						'@med_atend_prim = Primeiro nome do médico resposável do atendimento'|| chr(13) ||
						'@med_resp = Nome do resposável do atendimento'|| chr(13) ||
						'@especialidade_dest = Especialidade origem parecer' || chr(13) ||
						'@especialidade_dest_prof = Especialidade dest parecer' || chr(13) ||
						'@tipo_parecer = Tipo parecer' || chr(13) ||
						'@equipe_parecer = Equipe dest parecer'|| chr(13)*/
 ||
						'@ds_exame_solicitacao = Exame solicitado' || chr(13) ||
						'@ds_proc_solicitacao = Procedimento solicitado' || chr(13) ||
						'@qt_exame_solicitacao = Qtd. Exame solicitado' || chr(13) ||
						'@ds_exame_sem_cad_solic = Exame sem cadastro' || chr(13) ||
						'@lista_equip_agenda = Equipamentos da agenda' || chr(13) ||
						'@submotivo_alta = Submotivo alta' || chr(13) ||
						'@servico_pac	= Serviço para o paciente' || chr(13) ||
						'@nm_avaliador_aval = Nome do médico que fez a última avaliação'  || chr(13) ||
						'@dt_avaliacao = Data da última avaliação' || chr(13) ||
						'@endereco_compelto = Endereço completo do paciente'  || chr(13) ||
						'@seq_instituicao = Sequência da instituição' || chr(13) ||
						'@razao_social = Razão social' || chr(13) ||
						'@nr_telefone = Telefone da instituicao' || chr(13) ||
						'@nr_ramal = Ramal da instituição' || chr(13) ||
						'@ds_instituicao = Descrição da instituição' || chr(13) ||
						'@cd_cnes = Código CNES da instiuição' || chr(13) ||
						'@nr_adiant_pago = Número(s) do(s) adiantamento(s) pago(s) vinculado(s) ao(s) título(s)' || chr(13) ||
						'@vl_adiant_tit_pagar = Valor(es) do(s) adiantamento(s) vinculado(s) ao(s) titulo(s)' || chr(13) ||
						'@nm_fornec_adiant_pago = Fornecedor do(s) adiantamento(s)' || chr(13) ||
						obter_desc_expressao(782579)/*'@medicamento = Medicamento solicitado'*/
 ||
						'@nr_ordem_compra_adiant = Ordem(s) de compra vinculada ao(s) adiantamento(s)',1,4000);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macro_alerta_evento () FROM PUBLIC;

