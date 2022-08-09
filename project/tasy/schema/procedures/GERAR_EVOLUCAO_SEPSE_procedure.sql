-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evolucao_sepse (nr_seq_escala_p bigint, nm_usuario_p text) is ds_escala_w varchar(32000) RETURNS ESCALA_SEPSE_STATUS%ROWTYPE AS $body$
DECLARE


status_atual_w escala_sepse_status%rowtype;

BEGIN

	select max(dt_atualizacao_nrec), max(nm_usuario_nrec), max(ds_justif_status), max(ie_status_sepsis), max(ds_justif_status)
	into STRICT   status_atual_w.dt_atualizacao_nrec, status_atual_w.nm_usuario_nrec, status_atual_w.ds_justif_status, status_atual_w.ie_status_sepsis, status_atual_w.ds_justif_status
	from   escala_sepse_status
	where  nr_seq_escala_ped = nr_seq_escala_p
	and    ie_status_sepsis = coalesce(ie_status_p,ie_status_sepsis)
	and    dt_avaliacao between coalesce(dt_avaliacao_p,dt_avaliacao) - 0.0001 and (coalesce(dt_avaliacao_p,dt_avaliacao) + 0.0001);
	
	return status_atual_w;

end;

function date_to_char(dt_atual_w date) return varchar2 is

	begin
	  return PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_atual_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone);

end;

function obter_dados_acao(ie_status_p varchar2, dt_atual_p date, nr_atendimento_p number) return varchar2 is

c02 CURSOR FOR
	SELECT	e.nr_sequencia, e.ds_regra, f.ds_acao ds_acao, b.nr_sequencia NR_SEQ_PEND_PAC_ACAO, c.dt_justificativa dt_justificativa, c.ds_justificativa ds_justificativa, c.nr_seq_justificativa nr_seq_justificativa
	FROM	pessoa_fisica d,
			gqa_pendencia_pac a,
			GQA_PEND_PAC_ACAO b,
			GQA_PEND_PAC_ACAO_DEST c,
			gqa_pendencia_regra e,
			GQA_ACAO f
	WHERE	a.nr_sequencia = b.nr_seq_pend_pac
	AND		b.nr_sequencia = c.nr_seq_pend_pac_acao
	AND		d.cd_pessoa_fisica = a.cd_pessoa_fisica
	AND     a.nr_seq_pend_regra = e.nr_sequencia
	AND     b.nr_seq_regra_acao = f.nr_sequencia
	AND     e.nr_seq_escala = 178
	AND     e.ie_regra_sepse = ie_status_p
	AND     e.ie_situacao = 'A'
	AND     f.ie_situacao = 'A'
	AND     a.ie_escala = 201
	AND		c.cd_pessoa_fisica = OBTER_PESSOA_FISICA_USUARIO(nm_usuario_p,'C')
	AND		a.nr_atendimento    = nr_atendimento_p
	AND		(((b.nr_seq_proc IS NOT NULL AND b.nr_seq_proc::text <> '') OR (b.nr_seq_proc_saps IS NOT NULL AND b.nr_seq_proc_saps::text <> '')) OR (b.nr_seq_protocolo IS NOT NULL AND b.nr_seq_protocolo::text <> ''))
	AND     c.dt_atualizacao_nrec BETWEEN dt_atual_p - 0.0001  AND dt_atual_p + 0.0001;
	
ds_acoes_w 	   varchar2(32000) := ' ';
nr_seq_atual_w number(10);

begin
nr_seq_atual_w := 0;
for acao in c02 loop
	if (nr_seq_atual_w <> acao.nr_sequencia) then
		ds_acoes_w := '\b ' || obter_desc_expressao(285675, 'Conduta') ||' \b0 : ' || acao.ds_regra || p_linha_w;
		nr_seq_atual_w := acao.nr_sequencia;
	end if;
	
	select count(*)
	into STRICT 	qt_reg_pend_w
	from 	prescr_medica
	where 	nr_seq_pend_pac_acao = acao.nr_seq_pend_pac_acao
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
	
	if (qt_reg_pend_w > 0) then
		select CASE WHEN coalesce(acao.dt_justificativa::text, '') = '' THEN ''  ELSE ' ('||obter_desc_expressao(501152) ||')' END  ds_complemento -- Aplicado
		into STRICT ds_complemento_w
		;
	else
		if (acao.nr_seq_justificativa IS NOT NULL AND acao.nr_seq_justificativa::text <> '') then
			select 	max(nm_justificativa) || ': '
			into STRICT	nm_justificativa_w
			from	GQA_PEND_JUSTIFICATIVA
			where	nr_sequencia = acao.nr_seq_justificativa;
		else
			nm_justificativa_w := '';
		end if;
				
		select CASE WHEN coalesce(acao.dt_justificativa::text, '') = '' THEN ''  ELSE ' ('||obter_desc_expressao(891655) || ' - ' || nm_justificativa_w || acao.ds_justificativa||')' END  ds_complemento -- Nao aplicada
		into STRICT ds_complemento_w
		;
	end if;
	ds_acoes_w := ds_acoes_w || acao.ds_acao || ds_complemento_w || p_linha_w;
	
end loop;

return ds_acoes_w;

end;
							
begin

if (nr_seq_escala_p > 0) then

	select	coalesce(max(ie_situacao),'A')
	into STRICT	ie_situacao_w
	from	tipo_evolucao
	where	cd_tipo_evolucao = 'SP';
	
	if (ie_situacao_w = 'A') then

		/*Titulo da escala*/

		ds_escala_w := '\b ' || obter_desc_expressao(888131, 'Sepse Pediatrica') || ' \b0 : ';
		
		select *
		into STRICT   escala_w
		from   escala_sepse_infantil
		where  nr_sequencia = nr_seq_escala_p;
		
		ie_automatico_w := 'S';
		for itens_w in c01 loop
			ds_itens_w := ds_itens_w || itens_w.ds_item || ' ('||obter_desc_expressao(301251, 'Valor')||': '||itens_w.vl_item|| itens_w.unidade_medida||') '||p_linha_w;
		end loop;
		
		ds_escala_w := ds_escala_w
				/*Data e hora da geracoo automatica da escala com o status*/

			|| p_linha_w || '\b ' || obter_desc_expressao(316259,'Geracao automatica') || ' \b0 : ' || Obter_Valor_Dominio(8917, escala_w.ie_status_sepsis) || ' (' || date_to_char(escala_w.dt_atualizacao_nrec) || ')'			
				/*Descricao dos deflagradores estartados automaticamente*/

			|| p_linha_w || obter_desc_expressao(891585,'Deflagradores automaticos') || ': ' || p_linha_w || ds_itens_w || p_linha_w;
		
		status_w := obter_dados_status('SM'); --Suspeita de sepse aguardando acao da equipe
		if (status_w.dt_atualizacao_nrec IS NOT NULL AND status_w.dt_atualizacao_nrec::text <> '') then
			ds_usuario_w := Obter_Valor_Dominio(72,OBTER_FUNCAO_USUARIO(status_w.nm_usuario_nrec));
			/*Data e hora da primeira avaliacaoo do enfermeiro ou profissional em tela - levar o nome do profissional, status da acaoo tomada (se foi descartada com a justificativa do descarte ou se foi confirmada gerando o novo statu para o medico)*/

			ds_escala_w := ds_escala_w || '\b ' || obter_desc_expressao(891591,'Primeira avaliacao equipe' )|| ' \b0 : '|| date_to_char(status_w.dt_atualizacao_nrec) || p_linha_w
				|| obter_desc_expressao(296509, 'Profissional') || ': ' || Obter_Nome_Usuario(status_w.nm_usuario_nrec) || ' (' || ds_usuario_w || ')' || p_linha_w;
				
			-- Verificar se possui outros status
			select count(1)
			into STRICT   qt_reg_w
			from   escala_sepse_status
			where  nr_seq_escala_ped = nr_seq_escala_p
			and    ie_status_sepsis not in ('SE','SM','D');

			-- Se so possui o inicial, equipe e descarte, equipe descartou.
			if (qt_reg_w = 0) then
				status_w := obter_dados_status('D');
				ds_escala_w := ds_escala_w || obter_desc_expressao(892739,'Acao descartada')
					|| p_linha_w || obter_desc_expressao(720315, 'Classificacao') ||': '|| Obter_Valor_Dominio(8917, status_w.ie_status_sepsis)
					|| p_linha_w || obter_desc_expressao(882314,'Justificativa') || ': '|| status_w.ds_justif_status || p_linha_w || p_linha_w;
			else
				ds_escala_w := ds_escala_w || obter_desc_expressao(892741,'Acao confirmada') || p_linha_w || p_linha_w;
			end if;
		end if;
		
		status_w := obter_dados_status('SA'); --Suspeita de sepse aguardando acao medica
		if (status_w.dt_atualizacao_nrec IS NOT NULL AND status_w.dt_atualizacao_nrec::text <> '') then
			ds_usuario_w := Obter_Valor_Dominio(72,OBTER_FUNCAO_USUARIO(status_w.nm_usuario_nrec));
			/*Data e hora da primeira avaliacao do enfermeiro ou profissional em tela - levar o nome do profissional, status da acao tomada (se foi descartada com a justificativa do descarte ou se foi confirmada gerando o novo statu para o medico)*/

			ds_escala_w := ds_escala_w || '\b ' || obter_desc_expressao(892614,'Primeira avaliacao medica' )|| ' \b0 : '|| date_to_char(status_w.dt_atualizacao_nrec) || p_linha_w
				|| obter_desc_expressao(296509, 'Profissional') || ': ' || Obter_Nome_Usuario(status_w.nm_usuario_nrec) || ' (' || ds_usuario_w || ')' || p_linha_w;
				
			-- Verificar se possue outros status
			select count(1)
			into STRICT   qt_reg_w
			from   escala_sepse_status
			where  nr_seq_escala_ped = nr_seq_escala_p
			and    ie_status_sepsis not in ('SE','SM','SA','D');
						
			-- Se so possui o inicial, equipe. medico e descarte, verificar se medico descartou.
			if (qt_reg_w = 0) then
				status_w := obter_dados_status('D');
				-- Verificar se foi finalizado automatico
				if (escala_w.dt_fim_protocolo between status_w.dt_atualizacao_nrec - 0.0001 and status_w.dt_atualizacao_nrec + 0.0001) then
					ds_escala_w := ds_escala_w || obter_desc_expressao(892739,'Acao descartada')
						|| p_linha_w || obter_desc_expressao(720315, 'Classificacao') ||': '|| Obter_Valor_Dominio(8917, status_w.ie_status_sepsis)
						|| p_linha_w || obter_desc_expressao(882314,'Justificativa') || ': '|| status_w.ds_justif_status || p_linha_w || p_linha_w;
				else
					ds_escala_w := ds_escala_w || obter_desc_expressao(892741,'Acao confirmada') || p_linha_w || p_linha_w;
				end if;
			else	
				ds_escala_w := ds_escala_w || obter_desc_expressao(892741,'Acao confirmada') || p_linha_w || p_linha_w;
			end if;
		end if;
		
		/*Data e hora da primeira avaliacao medica registrada na escala - nome do profissional que realizou*/

		if (escala_w.dt_liberacao_aval IS NOT NULL AND escala_w.dt_liberacao_aval::text <> '') then
			ds_usuario_w := Obter_Valor_Dominio(72,OBTER_FUNCAO_USUARIO(escala_w.nm_usuario_aval));
			status_w := obter_dados_status(null, escala_w.dt_liberacao_aval);

			/*Descricao de todos os Deflagradores confirmados pelo medico (tanto automaticos como os manuais)*/

			ds_itens_w := '';
			ie_automatico_w := 'N';
			for itens_w in c01 loop
				ds_itens_w := ds_itens_w || itens_w.ds_item;
				if (itens_w.vl_item IS NOT NULL AND itens_w.vl_item::text <> '') then
					ds_itens_w := ds_itens_w || ' ('||obter_desc_expressao(301251, 'Valor')||': '||itens_w.vl_item||itens_w.unidade_medida||') ';
				end if;
				ds_itens_w := ds_itens_w||p_linha_w;
			end loop;
			
			ds_escala_w := ds_escala_w || '\b '|| obter_desc_expressao(601588,'Avaliacao medica') || '\b0 : '|| date_to_char(escala_w.dt_liberacao_aval) || p_linha_w
				|| obter_desc_expressao(296509, 'Profissional') || ': ' || Obter_Nome_Usuario(escala_w.nm_usuario_aval) || ' ('||ds_usuario_w||')' || p_linha_w
				|| obter_desc_expressao(891597, 'Deflagradores confirmados') ||': '|| p_linha_w || ds_itens_w
				|| '\b ' || obter_desc_expressao(888837, 'Paciente apresenta historia sugestiva de infeccao bacteriana/fungica') || ' \b0 : ' || p_linha_w;
				
				/*Informacoes selecionadas na avaliacao inicial*/

				if (escala_w.ie_infeccao_bac_fung = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(327114) || p_linha_w;
				end if;
				if (escala_w.ie_pneumonia_empiema = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888839) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_urinaria = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(291913) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_abdominal_ag = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888845) || p_linha_w;
				end if;
				if (escala_w.ie_meningite = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(293188) || p_linha_w;
				end if;
				if (escala_w.ie_endocardite = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888849) || p_linha_w;
				end if;
				if (escala_w.ie_pele_parte_mole = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888851) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_protese = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888855) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_ossea = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888857) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_ferida_op = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888859) || p_linha_w;
				end if;
				if (escala_w.ie_sem_foco_def = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888865) || p_linha_w;
				end if;
				if (escala_w.ie_infeccao_corrente_sang = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(888861) || p_linha_w;
				end if;
				if (escala_w.ie_outras_infeccoes = 'S') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(295048) || p_linha_w;
				end if;
				/*Observacoes adicionais imputadas na avaliacao inicial*/

				if (escala_w.ds_observacao_aval1 IS NOT NULL AND escala_w.ds_observacao_aval1::text <> '') then
					ds_escala_w := ds_escala_w || obter_desc_expressao(294639) ||': '||escala_w.ds_observacao_aval1 || p_linha_w;
				end if;
				
				/*Status confirmado pelo medico pps avaliacao inicial*/

				status_w := obter_dados_status(null, escala_w.dt_liberacao_aval);
				ds_escala_w := ds_escala_w || '\b '|| obter_desc_expressao(720315, 'Classificacao') || ' \b0 : ' || Obter_Valor_Dominio(8917, status_w.ie_status_sepsis) || p_linha_w;
				if (status_w.ie_status_sepsis in ('D','RD')) then
					ds_escala_w := ds_escala_w || obter_desc_expressao(882314,'Justificativa') || ': '|| status_w.ds_justif_status || p_linha_w;
				end if;
				/*Regras cadastradas no SDC*/

				ds_escala_w := ds_escala_w || obter_dados_acao(status_w.ie_status_sepsis, escala_w.dt_liberacao_aval, escala_w.nr_atendimento) || p_linha_w;
				
		end if;
		
		/*Data e hora da reavaliacao com o nome do profissional da reavaliacao*/

		if (escala_w.dt_liberacao_reaval IS NOT NULL AND escala_w.dt_liberacao_reaval::text <> '') then
			ds_usuario_w := Obter_Valor_Dominio(72,OBTER_FUNCAO_USUARIO(escala_w.nm_usuario_reaval));
			status_w := obter_dados_status(null, escala_w.dt_liberacao_reaval);		
			ds_escala_w := ds_escala_w || '\b '|| obter_desc_expressao(320773,'Reavaliacao medica') || '\b0 : '|| date_to_char(escala_w.dt_liberacao_reaval) || p_linha_w
				|| obter_desc_expressao(296509, 'Profissional') || ': ' || Obter_Nome_Usuario(escala_w.nm_usuario_aval) || ' ('||ds_usuario_w||')' || p_linha_w
				|| '\b ' || obter_desc_expressao(891659, 'Apos exames e ressuscitacao volemica, houve persistencia de') || ' \b0 : ' || p_linha_w;
				
			/*Descricao das informacoes marcadas na reavaliacao*/

			if (escala_w.ie_alt_perfusao = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(888869) || p_linha_w;
			end if;
			if (escala_w.ie_oliguria = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889133) || p_linha_w;
			end if;
			if (escala_w.ie_hipotensao = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(888867) || p_linha_w;
			end if;
			if (escala_w.ie_lactato_2x_ref = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889125) || p_linha_w;
			end if;
			if (escala_w.ie_dif_temp_central = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889127) || p_linha_w;
			end if;
			if (escala_w.ie_acidose_metabolica = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889129) || p_linha_w;
			end if;
			if (escala_w.ie_inr_plaquetas = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889135) || p_linha_w;
			end if;
			if (escala_w.ie_creatinina = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889141) || p_linha_w;
			end if;
			if (escala_w.ie_bilirrubina = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889145) || p_linha_w;
			end if;
			if (escala_w.ie_glasgow = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889147) || p_linha_w;
			end if;
			if (escala_w.ie_pao_fio = 'S') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(889149) || p_linha_w;
			end if;
			/*Observacoes adicionais imputadas na reavaliacao*/

			if (escala_w.ds_observacao_reaval IS NOT NULL AND escala_w.ds_observacao_reaval::text <> '') then
				ds_escala_w := ds_escala_w || obter_desc_expressao(294639) || ': '|| escala_w.ds_observacao_reaval ||  p_linha_w;
			end if;
			
			/*Status final confirmado da reavaliacao*/

			ds_escala_w := ds_escala_w || '\b '||obter_desc_expressao(720315, 'Classificacao') || ' \b0 : ' || Obter_Valor_Dominio(8917, status_w.ie_status_sepsis) || p_linha_w;
			if (status_w.ie_status_sepsis in ('D','RD')) then
				ds_escala_w := ds_escala_w || obter_desc_expressao(882314,'Justificativa') || ': '|| status_w.ds_justif_status || p_linha_w || p_linha_w;
			end if;
			
			/*Regras cadastradas no SDC*/

			ds_escala_w := ds_escala_w || obter_dados_acao(status_w.ie_status_sepsis, escala_w.dt_liberacao_reaval, escala_w.nr_atendimento) || p_linha_w;
			
		end if;
		
		if (escala_w.dt_fim_protocolo IS NOT NULL AND escala_w.dt_fim_protocolo::text <> '') then
			ds_usuario_w := Obter_Valor_Dominio(72,OBTER_FUNCAO_USUARIO(escala_w.nm_usuario_fim));
			ds_escala_w := ds_escala_w ||'\b '||obter_desc_expressao(890779,'Finalizacao do protocolo de Sepse')||' \b0 : '
				|| p_linha_w || obter_desc_expressao(286922,'Data finalizacao') ||': '||date_to_char(escala_w.dt_fim_protocolo)
				|| p_linha_w || obter_desc_expressao(296509, 'Profissional') || ': ' || Obter_Nome_Usuario(escala_w.nm_usuario_fim) || ' ('||ds_usuario_w||')'
				|| p_linha_w || obter_desc_expressao(891984, 'Justificativa fim protocolo') ||': '|| escala_w.ds_justificativa_fim;
		end if;
		
		select	somente_numero(max(qt_tamanho_fonte)) * 2,
				max(ds_fonte)
		into STRICT 	nr_tam_fonte_w,
				ds_fonte_w
		from	configuracao_panel_editor
		where	coalesce(cd_funcao,281) = 281
		and 	coalesce(upper(nm_usuario_config),coalesce(upper(nm_usuario_p),0)) = coalesce(upper(nm_usuario_p),0)
		and 	coalesce(cd_estabelecimento,coalesce(obter_estabelecimento_ativo,0)) = coalesce(obter_estabelecimento_ativo,0)
		and 	coalesce(cd_perfil,coalesce(obter_perfil_ativo,0)) = coalesce(obter_perfil_ativo,0)
		and	coalesce(upper(nm_tabela),upper('EVOLUCAO_PACIENTE')) = upper('EVOLUCAO_PACIENTE')
		order by
			coalesce(nm_usuario_config,'AAAAAAAA'),
			coalesce(cd_funcao,0),
			coalesce(cd_perfil,0),
			coalesce(cd_estabelecimento,0);
			
		/*Geracao RTF*/
	
		
		/*inicio substituir os caracteres chr(13) e chr(10) pelo \par que que representa o enter no rtf*/

		qt_controle_chr_w :=0;
			
		while(position(chr(13) in ds_escala_w) > 0) and (qt_controle_chr_w < 100) loop
			ds_escala_w := replace(ds_escala_w, chr(13), '\par ');
			qt_controle_chr_w := qt_controle_chr_w + 1;
		end loop;
		qt_controle_chr_w := 0;

		while(position(chr(10) in ds_escala_w) > 0) and (qt_controle_chr_w < 100) loop
			ds_escala_w := replace(ds_escala_w, chr(10), '');
			qt_controle_chr_w := qt_controle_chr_w + 1;
		end loop;
		
		/*fim substituir os caracteres chr(13) e chr(10) pelo \par que que representa o enter no rtf*/


		/*pega o cabecalho do rtf*/

		ds_cabecalho_w := '{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 Arial;}{\f1\fnil Arial;}}' ||
							'{\colortbl ;\red0\green0\blue0;}' ||
							'\viewkind4\uc1\pard\cf1\lang1046\fs20  \fs16 \f1 ';
		ds_pos_inicio_rtf_w := position('lang' in ds_cabecalho_w) + 8;
		ds_conteudo_w := substr(ds_cabecalho_w, 1, ds_pos_inicio_rtf_w) || 'fs20 ';
		
		/*acrecenta conteudo texto livre*/

		ds_conteudo_w := ds_conteudo_w || ds_escala_w;
		
		/*acrecenta resto do conteudo do rtf*/

		ds_rodape_w   := '}';
		ds_conteudo_w := ds_conteudo_w || '\par ' || substr(ds_cabecalho_w, ds_pos_inicio_rtf_w, length(ds_cabecalho_w));
		ds_conteudo_w  := ds_conteudo_w || ' ' || ds_rodape_w;
		
		insert into evolucao_paciente(
			cd_evolucao,
			dt_evolucao,
			ie_tipo_evolucao,
			cd_pessoa_fisica,
			dt_atualizacao,
			nm_usuario,
			nr_atendimento,
			ds_evolucao,
			cd_medico,
			dt_liberacao,
			ie_evolucao_clinica,
			ie_situacao)
		values (nextval('evolucao_paciente_seq'),
			clock_timestamp(),
			OBTER_FUNCAO_USUARIO(nm_usuario_p),
			OBTER_PESSOA_ATENDIMENTO(escala_w.nr_atendimento,'C'),
			clock_timestamp(),
			nm_usuario_p,
			escala_w.nr_atendimento,
			ds_conteudo_w,
			Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'),
			clock_timestamp(),
			'SP',
			'A');
			
		commit;
		
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evolucao_sepse (nr_seq_escala_p bigint, nm_usuario_p text) is ds_escala_w varchar(32000) FROM PUBLIC;
