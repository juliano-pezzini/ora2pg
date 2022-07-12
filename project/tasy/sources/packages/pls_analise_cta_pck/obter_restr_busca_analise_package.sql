-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_analise_cta_pck.obter_restr_busca_analise ( dados_filtro_p table_dados_busca_analise, ie_select_p integer, nr_id_transacao_p pls_analise_conta_temp.nr_id_transacao%type, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


dados_restricao_w pls_util_pck.dados_select;
ie_status_w   varchar(255);
nr_inicial_w    integer;
nr_final_w    integer;


BEGIN
-- inicializa as vari?veis

dados_restricao_w.ds_campos := null;
dados_restricao_w.ds_tabelas := null;
dados_restricao_w.ds_restricao := null;

-- Sempre que vier pela sequ?ncia busca s? por isso.

if (dados_filtro_p.nr_seq_analise IS NOT NULL AND dados_filtro_p.nr_seq_analise::text <> '') then

  dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_sequencia = :nr_seq_analise', dados_restricao_w);
  valor_bind_p := sql_pck.bind_variable(':nr_seq_analise', dados_filtro_p.nr_seq_analise, valor_bind_p);

  dados_restricao_w := pls_util_pck.sql_restricao(
        ' and exists( select  1 ' || pls_util_pck.enter_w ||
        '     from  pls_lote_protocolo_conta x ' || pls_util_pck.enter_w ||
        '     where x.nr_sequencia = a.nr_seq_lote_protocolo ' || pls_util_pck.enter_w ||
        '     and x.ie_status not in (''X'', ''G'')) ', dados_restricao_w);

  dados_restricao_w := pls_util_pck.sql_campo( '1', 'qt_audit_atual', dados_restricao_w);
  dados_restricao_w := pls_util_pck.sql_campo( '1', 'qt_audit_fut', dados_restricao_w);
else
  -------------------------------------------- Dados da an?lise -------------------------------------------- 

  -- Situa??o da an?lise

  if (dados_filtro_p.nm_usuario_audit IS NOT NULL AND dados_filtro_p.nm_usuario_audit::text <> '') then
  
    if (dados_filtro_p.situacao_analise_rg_ii = 1) then  
            
      dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_status in (''A'', ''G'')', dados_restricao_w);

      dados_restricao_w := pls_util_pck.sql_campo( '(select count(1) ' || pls_util_pck.enter_w ||
            'from pls_auditoria_conta_grupo x ' || pls_util_pck.enter_w ||
            'where x.nr_seq_grupo = a.nr_seq_grupo_auditor' || pls_util_pck.enter_w || 
            'and x.nr_seq_analise = a.nr_sequencia ' || pls_util_pck.enter_w ||
            'and x.nm_auditor_atual = :nm_usuario_audit' || pls_util_pck.enter_w ||
            'and x.dt_liberacao is null)', 'qt_audit_atual', dados_restricao_w);

      dados_restricao_w := pls_util_pck.sql_campo( '(select count(1) ' || pls_util_pck.enter_w ||
            'from pls_membro_grupo_aud mg, ' || pls_util_pck.enter_w ||
            ' pls_auditoria_conta_grupo b ' ||  pls_util_pck.enter_w ||
            'where  mg.ie_situacao = ''A''' ||  pls_util_pck.enter_w ||
            'and mg.nr_seq_grupo = a.nr_seq_grupo_auditor ' ||  pls_util_pck.enter_w ||
            'and mg.nm_usuario_exec = :nm_usuario_audit ' ||  pls_util_pck.enter_w ||
            'and b.nr_seq_grupo = mg.nr_seq_grupo' ||  pls_util_pck.enter_w ||
            'and b.nm_auditor_atual is null ' ||  pls_util_pck.enter_w ||
            'and b.nr_seq_analise = a.nr_sequencia ' ||  pls_util_pck.enter_w ||
            'and b.dt_liberacao is null)', 'qt_audit_fut', dados_restricao_w);

      valor_bind_p := sql_pck.bind_variable(':nm_usuario_audit', dados_filtro_p.nm_usuario_audit, valor_bind_p);

    elsif (dados_filtro_p.situacao_analise_rg_ii = 2) then
    
      dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_atual', dados_restricao_w);

      dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_fut', dados_restricao_w);

      dados_restricao_w := pls_util_pck.sql_restricao(
        'and exists ( select  a.nr_sequencia ' || pls_util_pck.enter_w ||
        '       from    pls_auditoria_conta_grupo b ' || pls_util_pck.enter_w ||
        '       where   b.nr_seq_grupo  = a.nr_seq_grupo_auditor' || pls_util_pck.enter_w ||
        '       and     b.nr_seq_analise  = a.nr_sequencia' || pls_util_pck.enter_w ||
        '       and     b.nm_auditor_atual = :nm_usuario_audit ' || pls_util_pck.enter_w ||
        '       and     b.dt_liberacao is null ) ', dados_restricao_w);

      valor_bind_p := sql_pck.bind_variable(':nm_usuario_audit', dados_filtro_p.nm_usuario_audit, valor_bind_p);
    else
      dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_atual', dados_restricao_w);

      dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_fut', dados_restricao_w);
    end if;
  else
    dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_atual', dados_restricao_w);
    dados_restricao_w := pls_util_pck.sql_campo( '0', 'qt_audit_fut', dados_restricao_w);
  end if;

  -- Quando for 1 - Dt An?lise ou 2 - Dt Libera??o

  if (dados_filtro_p.ie_tipo_data_rg_ii in (1,2)) then
    
    -- Data de an?lise

    if (dados_filtro_p.ie_tipo_data_rg_ii = 1) then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and trunc(a.dt_analise, ''dd'') between :dt_de and :dt_ate', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
      valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);

    -- Libera??o da an?lise.

    elsif (dados_filtro_p.ie_tipo_data_rg_ii = 2) then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and trunc(a.dt_liberacao_analise, ''dd'') between :dt_de and :dt_ate', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
      valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);
    end if;
  end if;

  -- Grupo auditor atual da an?lise.

  if (dados_filtro_p.nr_seq_grupo_auditor_atual IS NOT NULL AND dados_filtro_p.nr_seq_grupo_auditor_atual::text <> '') then

    dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_seq_grupo_auditor = :nr_seq_grupo_auditor_atual', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_grupo_auditor_atual', dados_filtro_p.nr_seq_grupo_auditor_atual, valor_bind_p);
  end if;

  --Grupos auditores da an?lise.

  if (dados_filtro_p.nr_seq_grupo_auditor IS NOT NULL AND dados_filtro_p.nr_seq_grupo_auditor::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao(' AND EXISTS (SELECT a.nr_sequencia ' || pls_util_pck.enter_w ||
              ' FROM    pls_auditoria_conta_grupo c ' || pls_util_pck.enter_w ||
              ' WHERE   c.nr_seq_analise  = a.nr_sequencia ' || pls_util_pck.enter_w ||
              ' AND   c.nr_seq_grupo  = :nr_seq_grupo_auditor )', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_grupo_auditor', dados_filtro_p.nr_seq_grupo_auditor, valor_bind_p);
  end if;

  -- Pcmso

  if (dados_filtro_p.ie_pcmso_cb = 1) then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_pcmso = ''S''', dados_restricao_w);
  end if;

  -- BENEFICI?RIO PCMSO

  if (dados_filtro_p.ie_beneficiario_pcmso_cb = 1) then
    dados_restricao_w := pls_util_pck.sql_restricao('and exists (  select  1 ' || pls_util_pck.enter_w ||
              ' from  pls_segurado h ' || pls_util_pck.enter_w ||
              ' where h.nr_sequencia = a.NR_SEQ_SEGURADO ' || pls_util_pck.enter_w ||
              ' and h.IE_PCMSO = ''S'')', dados_restricao_w);
  end if;

  -- Origem selecionada no filtro

  if (dados_filtro_p.ie_origem_analise IS NOT NULL AND dados_filtro_p.ie_origem_analise::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_origem_analise = :ie_origem_analise', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':ie_origem_analise', dados_filtro_p.ie_origem_analise, valor_bind_p);

  -- Origem da an?lise nos par?metros

  elsif (dados_filtro_p.ie_origem_analise_in IS NOT NULL AND dados_filtro_p.ie_origem_analise_in::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_origem_analise in (' || dados_filtro_p.ie_origem_analise_in || ')', dados_restricao_w);
  end if;

  -- Origem da conta

  if (dados_filtro_p.ie_origem_conta IS NOT NULL AND dados_filtro_p.ie_origem_conta::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_origem_conta = :ie_origem_conta', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':ie_origem_conta', dados_filtro_p.ie_origem_conta, valor_bind_p);
  end if;

  -- Tipo de guia.

  if (dados_filtro_p.ie_tipo_guia IS NOT NULL AND dados_filtro_p.ie_tipo_guia::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_tipo_guia = :ie_tipo_guia', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':ie_tipo_guia', dados_filtro_p.ie_tipo_guia, valor_bind_p);
  end if;

  -- Status

  if (dados_filtro_p.ie_status IS NOT NULL AND dados_filtro_p.ie_status::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.ie_status = :ie_status', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':ie_status', dados_filtro_p.ie_status, valor_bind_p);
  end if;

  -- Regra de libera??o autom?tica

  if (dados_filtro_p.analise_lib_automatic_cb = 1) then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_seq_regra_lib is not null', dados_restricao_w);
  end if;

  -- Filtro por an?lise sem grupo auditor vinculado

  if (dados_filtro_p.analise_sem_grup_vin_cb = 1) then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and not exists  (select 1 ' || pls_util_pck.enter_w ||
                'from pls_auditoria_conta_grupo   grupo_auditoria ' || pls_util_pck.enter_w ||
                'where  grupo_auditoria.nr_seq_analise    = a.nr_sequencia) ', dados_restricao_w);
  end if;

  -- Benefici?rio

  if (dados_filtro_p.nr_seq_segurado IS NOT NULL AND dados_filtro_p.nr_seq_segurado::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_seq_segurado = :nr_seq_segurado', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_segurado', dados_filtro_p.nr_seq_segurado, valor_bind_p);
  end if;

  -- Lote de an?lise

  if (dados_filtro_p.nr_seq_lote_analise IS NOT NULL AND dados_filtro_p.nr_seq_lote_analise::text <> '') then   
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_seq_lote_protocolo = :nr_seq_lote_analise', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_lote_analise', dados_filtro_p.nr_seq_lote_analise, valor_bind_p);
  end if;

  -- Prestador

  if (dados_filtro_p.nr_seq_prestador IS NOT NULL AND dados_filtro_p.nr_seq_prestador::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.nr_seq_prestador = :nr_seq_prestador', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_prestador', dados_filtro_p.nr_seq_prestador, valor_bind_p);
  end if;

  -- Buscar por status

  if (dados_filtro_p.ds_status IS NOT NULL AND dados_filtro_p.ds_status::text <> '') then
    
    nr_inicial_w := position('(' in dados_filtro_p.ds_status);
    nr_final_w := (position(')' in dados_filtro_p.ds_status) - nr_inicial_w) + 1;
    ie_status_w := substr(dados_filtro_p.ds_status, nr_inicial_w, nr_final_w);

    dados_restricao_w := pls_util_pck.sql_restricao(' and a.ie_status in '||ie_status_w||'', dados_restricao_w);
    --sql_pck.bind_variable(':ie_status', ie_status_w, valor_bind_p);

  end if;

  -- Tipo prestador

  if (dados_filtro_p.nr_seq_tipo_prestador IS NOT NULL AND dados_filtro_p.nr_seq_tipo_prestador::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao('and exists (  select  1 ' || pls_util_pck.enter_w ||
                '                   from  pls_prestador   b' || pls_util_pck.enter_w ||
                '         where   a.nr_seq_prestador          = b.nr_sequencia' || pls_util_pck.enter_w ||
                '         and     b.nr_seq_tipo_prestador     = :nr_seq_tipo_prestador)', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(  ':nr_seq_tipo_prestador', dados_filtro_p.nr_seq_tipo_prestador, valor_bind_p);
  end if;

  -- Guia

  if (dados_filtro_p.cd_guia IS NOT NULL AND dados_filtro_p.cd_guia::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and a.cd_guia = :cd_guia', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':cd_guia', dados_filtro_p.cd_guia, valor_bind_p);
  end if;

  --Ocorr?ncia

  if (dados_filtro_p.nr_seq_ocorrencia IS NOT NULL AND dados_filtro_p.nr_seq_ocorrencia::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao('and exists (  select  1 ' || pls_util_pck.enter_w ||
                'from pls_ocorrencia_benef    b,' || pls_util_pck.enter_w ||
                ' pls_conta               c' || pls_util_pck.enter_w ||
                'where   c.nr_sequencia         = b.nr_seq_conta' || pls_util_pck.enter_w ||
                'and     a.nr_sequencia         = c.nr_seq_analise' || pls_util_pck.enter_w ||
                'and     b.nr_seq_ocorrencia  = :nr_seq_ocorrencia)', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_ocorrencia', dados_filtro_p.nr_seq_ocorrencia, valor_bind_p);
  end if;

    --Procedimento

  if (dados_filtro_p.cd_procedimento IS NOT NULL AND dados_filtro_p.cd_procedimento::text <> '' AND dados_filtro_p.ie_origem_proced IS NOT NULL AND dados_filtro_p.ie_origem_proced::text <> '') then

    dados_restricao_w := pls_util_pck.sql_restricao('and exists (  select  1 ' || pls_util_pck.enter_w ||
                'from pls_conta_proc      b,' || pls_util_pck.enter_w ||
                '   pls_conta               c' || pls_util_pck.enter_w ||
                'where   c.nr_sequencia         = b.nr_seq_conta' || pls_util_pck.enter_w ||
                'and     a.nr_sequencia         = c.nr_seq_analise' || pls_util_pck.enter_w ||
                'and     b.cd_procedimento    = :cd_procedimento' || pls_util_pck.enter_w ||
                'and     b.ie_origem_proced   = :ie_origem_proced)', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':cd_procedimento', dados_filtro_p.cd_procedimento, valor_bind_p);
    valor_bind_p := sql_pck.bind_variable(':ie_origem_proced', dados_filtro_p.ie_origem_proced, valor_bind_p);
  end if;

  -- Prazo de an?lise

  if (dados_filtro_p.qt_dias_prazo IS NOT NULL AND dados_filtro_p.qt_dias_prazo::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao('and ((a.dt_prazo_analise between sysdate and sysdate + :qt_dias_prazo) or (a.dt_prazo_analise <= sysdate))', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':qt_dias_prazo', dados_filtro_p.qt_dias_prazo, valor_bind_p);
  end if;

  -- obrigatoriamente precisa acessar toda a estrutura pelo motivo que no final acessa os lotes

  dados_restricao_w := pls_analise_cta_pck.obter_tab_sel_busca_analise('pls_conta', ie_select_p, dados_restricao_w, dados_filtro_p);

  -------------------------------------------- Dados da conta --------------------------------------------

  if ((dados_filtro_p.nr_seq_conta IS NOT NULL AND dados_filtro_p.nr_seq_conta::text <> '') or
    (dados_filtro_p.ie_tipo_conta IS NOT NULL AND dados_filtro_p.ie_tipo_conta::text <> '') or
    (dados_filtro_p.cd_guia_prest IS NOT NULL AND dados_filtro_p.cd_guia_prest::text <> '') or
    (dados_filtro_p.cd_guia_operadora IS NOT NULL AND dados_filtro_p.cd_guia_operadora::text <> '') or
    (dados_filtro_p.nr_seq_tipo_atendimento IS NOT NULL AND dados_filtro_p.nr_seq_tipo_atendimento::text <> '')) then
    
    -- Buscar da conta.

    if (dados_filtro_p.nr_seq_conta IS NOT NULL AND dados_filtro_p.nr_seq_conta::text <> '') then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and (conta.nr_sequencia = :nr_seq_conta', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_seq_conta', dados_filtro_p.nr_seq_conta, valor_bind_p);
      
      --Buscar guias do atendimento 

      if (dados_filtro_p.ie_buscar_guias_atend_cb = 1) then
        dados_restricao_w := pls_util_pck.sql_restricao(
          ' or conta.cd_guia_referencia = ( select  cta.cd_guia_referencia ' || pls_util_pck.enter_w ||
          '         from  pls_conta cta ' || pls_util_pck.enter_w ||
          '         where cta.nr_sequencia = :nr_seq_conta) ', dados_restricao_w);
        valor_bind_p := sql_pck.bind_variable(':nr_seq_conta', dados_filtro_p.nr_seq_conta, valor_bind_p);
      end if;

      dados_restricao_w := pls_util_pck.sql_restricao(' ) ', dados_restricao_w);
    end if;

    -- Tipo de conta

    if (dados_filtro_p.ie_tipo_conta IS NOT NULL AND dados_filtro_p.ie_tipo_conta::text <> '') then
    
      dados_restricao_w := pls_util_pck.sql_restricao('and conta.nr_seq_tipo_conta = :ie_tipo_conta', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':ie_tipo_conta', dados_filtro_p.ie_tipo_conta, valor_bind_p);
    end if;

    -- Tipo de atendimento da conta.

    if (dados_filtro_p.nr_seq_tipo_atendimento IS NOT NULL AND dados_filtro_p.nr_seq_tipo_atendimento::text <> '') then
      
      dados_restricao_w := pls_util_pck.sql_restricao(' and conta.nr_seq_tipo_atendimento = :nr_seq_tipo_atendimento ', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_seq_tipo_atendimento', dados_filtro_p.nr_seq_tipo_atendimento, valor_bind_p);
    end if;

    -- Guia Prestador

    if (dados_filtro_p.cd_guia_prest IS NOT NULL AND dados_filtro_p.cd_guia_prest::text <> '') then
    
      dados_restricao_w := pls_util_pck.sql_restricao('and conta.cd_guia_prestador = :cd_guia_prest', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':cd_guia_prest', dados_filtro_p.cd_guia_prest, valor_bind_p);
    end if;

    -- Guia Operadora

    if (dados_filtro_p.cd_guia_operadora IS NOT NULL AND dados_filtro_p.cd_guia_operadora::text <> '') then

      dados_restricao_w := pls_util_pck.sql_restricao('and conta.cd_guia = :cd_guia_operadora', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':cd_guia_operadora', dados_filtro_p.cd_guia_operadora, valor_bind_p);
    end if;
  end if;
  
  -- obrigatoriamente precisa acessar toda a estrutura pelo motivo que no final acessa os lotes

  dados_restricao_w := pls_analise_cta_pck.obter_tab_sel_busca_analise('pls_protocolo_conta', ie_select_p, dados_restricao_w, dados_filtro_p);

  -------------------------------------------- Dados do protocolo --------------------------------------------

  if ((dados_filtro_p.nr_seq_protocolo IS NOT NULL AND dados_filtro_p.nr_seq_protocolo::text <> '') or
    (dados_filtro_p.nr_protocolo_prestador IS NOT NULL AND dados_filtro_p.nr_protocolo_prestador::text <> '') or
    dados_filtro_p.ie_refaturamento in (1,2) or
    dados_filtro_p.tipo_apresentacao_rg_ii in (1,2) or
    dados_filtro_p.ie_tipo_data_rg_ii = 3 or
    dados_filtro_p.ie_tipo_data_rg_ii = 4 ) then

    -- Mes de Competencia

    if (dados_filtro_p.ie_tipo_data_rg_ii = 3) then
    
      if (dados_filtro_p.ie_origem_analise in (4,8)) then
        dados_restricao_w := pls_util_pck.sql_restricao('and trunc(prec.dt_competencia_lote, ''month'') between trunc(:dt_de, ''month'') and trunc(:dt_ate, ''month'')', dados_restricao_w);
        valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
        valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);
      else
        dados_restricao_w := pls_util_pck.sql_restricao('and trunc(proto.dt_mes_competencia, ''month'') between trunc(:dt_de, ''month'') and trunc(:dt_ate, ''month'')', dados_restricao_w);
        valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
        valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);
      end if;

    -- Recebimento do Protocolo

    elsif (dados_filtro_p.ie_tipo_data_rg_ii = 4) then

      if (dados_filtro_p.ie_origem_analise in (4,8)) then
        dados_restricao_w := pls_util_pck.sql_restricao('and prec.dt_apresentacao_lote between :dt_de and :dt_ate', dados_restricao_w);
        valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
        valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);
      else
        dados_restricao_w := pls_util_pck.sql_restricao('and proto.dt_recebimento between :dt_de and :dt_ate', dados_restricao_w);
        valor_bind_p := sql_pck.bind_variable(':dt_de', inicio_dia(dados_filtro_p.dt_de), valor_bind_p, sql_pck.b_data_hora);
        valor_bind_p := sql_pck.bind_variable(':dt_ate', fim_dia(dados_filtro_p.dt_ate), valor_bind_p, sql_pck.b_data_hora);
      end if;
    end if;

    -- Buscar do protocolo

    if (dados_filtro_p.nr_seq_protocolo IS NOT NULL AND dados_filtro_p.nr_seq_protocolo::text <> '') then
      
      dados_restricao_w := pls_util_pck.sql_restricao(' and proto.nr_sequencia = :nr_seq_protocolo ', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_seq_protocolo', dados_filtro_p.nr_seq_protocolo, valor_bind_p);
    end if;

    -- n?mero do protcolo no prestador.

    if (dados_filtro_p.nr_protocolo_prestador IS NOT NULL AND dados_filtro_p.nr_protocolo_prestador::text <> '') then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and proto.nr_protocolo_prestador = :nr_protocolo_prestador', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_protocolo_prestador', dados_filtro_p.nr_protocolo_prestador, valor_bind_p);
    end if;

    -- Protocolo de apresenta??o\Reapresenta??o.

    if (dados_filtro_p.tipo_apresentacao_rg_ii in (1,2)) then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and proto.ie_apresentacao = :ie_apresentacao', dados_restricao_w);

      if (dados_filtro_p.tipo_apresentacao_rg_ii = 1) then
      
        valor_bind_p := sql_pck.bind_variable(':ie_apresentacao', 'A', valor_bind_p);
      else
        valor_bind_p := sql_pck.bind_variable(':ie_apresentacao', 'R', valor_bind_p);
      end if;
    end if;

    if (dados_filtro_p.ie_refaturamento in (1,2)) then
      dados_restricao_w := pls_util_pck.sql_restricao('and nvl(proto.ie_refaturamento,''N'') = :ie_refaturamento', dados_restricao_w);

      if (dados_filtro_p.ie_refaturamento = 1) then
      
        valor_bind_p := sql_pck.bind_variable(':ie_refaturamento', 'S', valor_bind_p);
      else
        valor_bind_p := sql_pck.bind_variable(':ie_refaturamento', 'N', valor_bind_p);
      end if;
    end if;

  end if;

  -------------------------------------------- Dados do interc?mbio --------------------------------------------

  -- Montar o acesso apenas at? a pls_intercambio

  -- Toda a restri??o destas tabelas deve entrar aqui neste primeiro n?vel para garantir o exists.

  -- Depois deve repetir num if ?nico para montar a restri??o do exists.

  if (dados_filtro_p.cd_contrato_int IS NOT NULL AND dados_filtro_p.cd_contrato_int::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg_int, ' || pls_util_pck.enter_w ||
      '     pls_intercambio interc ' || pls_util_pck.enter_w ||
      '   where seg_int.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and interc.nr_sequencia = seg_int.nr_seq_intercambio ', dados_restricao_w);

    -- Se veio a sequ?ncia do contrato j? ve se ? o do benefici?rio da an?lise.

      
    dados_restricao_w := pls_util_pck.sql_restricao('and seg_int.nr_seq_intercambio = :cd_contrato_int', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':cd_contrato_int', dados_filtro_p.cd_contrato_int, valor_bind_p);

    dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao ||')';
  end if;

  if (dados_filtro_p.nr_seq_oper_congenere IS NOT NULL AND dados_filtro_p.nr_seq_oper_congenere::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg_int ' || pls_util_pck.enter_w ||
      '   where seg_int.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and seg_int.nr_seq_ops_congenere  = :nr_seq_oper_congenere
          union all '|| pls_util_pck.enter_w ||
      '   select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg_int ' || pls_util_pck.enter_w ||
      '   where seg_int.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and seg_int.nr_seq_congenere  = :nr_seq_oper_congenere) ', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':nr_seq_oper_congenere', dados_filtro_p.nr_seq_oper_congenere, valor_bind_p);

  end if;

  -------------------------------------------- Dados do Lote de contesta??o -------------------------------------------- 

  -- Montar acesso pela estrutura da contesta??o num ?nico exists:

  -- Toda a restri??o ddestas deve entrar aqui neste primeiro n?vel para garantir o exists.

  -- Depois deve repetir num if ?nico para montar a restri??o do exists.

  if (dados_filtro_p.nr_seq_lote_contest IS NOT NULL AND dados_filtro_p.nr_seq_lote_contest::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_contestacao_discussao contest, ' || pls_util_pck.enter_w ||
      '     pls_lote_discussao lote_disc, ' || pls_util_pck.enter_w ||
      '     pls_lote_contestacao lote_contest ' || pls_util_pck.enter_w ||
      '   where contest.nr_seq_analise = a.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and lote_disc.nr_sequencia = contest.nr_seq_lote ' || pls_util_pck.enter_w ||
      '   and lote_contest.nr_sequencia = lote_disc.nr_seq_lote_contest', dados_restricao_w);

    -- Lote de contestacao.

    if (dados_filtro_p.nr_seq_lote_contest IS NOT NULL AND dados_filtro_p.nr_seq_lote_contest::text <> '') then
    
      dados_restricao_w := pls_util_pck.sql_restricao('and lote_contest.nr_sequencia = :nr_seq_lote_contest', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_seq_lote_contest', dados_filtro_p.nr_seq_lote_contest, valor_bind_p);
    end if;

    dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao ||')';
  end if;

  -------------------------------------------- Dados do plano -------------------------------------------- 

  -- Forma??o de pre?o do benefici?rio

  if (dados_filtro_p.ie_formacao_preco IS NOT NULL AND dados_filtro_p.ie_formacao_preco::text <> '') then
    
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg_plano, ' || pls_util_pck.enter_w ||
      '     pls_plano plano ' || pls_util_pck.enter_w ||
      '   where seg_plano.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and plano.nr_sequencia = seg_plano.nr_seq_plano ' || pls_util_pck.enter_w ||
      '   and plano.ie_preco = :ie_formacao_preco) ', dados_restricao_w);

    valor_bind_p := sql_pck.bind_variable(':ie_formacao_preco', dados_filtro_p.ie_formacao_preco, valor_bind_p);
  end if;

  -------------------------------------------- Dados do benfici?rio -------------------------------------------- 

  if (dados_filtro_p.cd_contrato IS NOT NULL AND dados_filtro_p.cd_contrato::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg ' || pls_util_pck.enter_w ||
      '   where seg.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and seg.nr_seq_contrato = :cd_contrato ) ', dados_restricao_w);

    valor_bind_p := sql_pck.bind_variable(':cd_contrato', dados_filtro_p.cd_contrato, valor_bind_p);
  end if;

  -- Tipo segurado

  if (dados_filtro_p.ie_tipo_segurado IS NOT NULL AND dados_filtro_p.ie_tipo_segurado::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado seg ' || pls_util_pck.enter_w ||
      '   where seg.nr_sequencia = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and   seg.ie_tipo_segurado = :ie_tipo_segurado ) ', dados_restricao_w);
    valor_bind_p := sql_pck.bind_variable(':ie_tipo_segurado', dados_filtro_p.ie_tipo_segurado, valor_bind_p);
  end if;

  -------------------------------------------- Dados da carteira -------------------------------------------- 

  -- C?digo do cart?o

  if (dados_filtro_p.cd_usuario_plano IS NOT NULL AND dados_filtro_p.cd_usuario_plano::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_segurado_carteira cartao ' || pls_util_pck.enter_w ||
      '   where cartao.nr_seq_segurado = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
      '   and cartao.cd_usuario_plano = :cd_usuario_plano ) ', dados_restricao_w);

    valor_bind_p := sql_pck.bind_variable(':cd_usuario_plano', dados_filtro_p.cd_usuario_plano, valor_bind_p);
  end if;

  -------------------------------------------- Dados do prestador -------------------------------------------- 

  -- C?digo do cart?o

  if (dados_filtro_p.cd_prestador IS NOT NULL AND dados_filtro_p.cd_prestador::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_restricao(
      ' and exists (  select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_prestador prest ' || pls_util_pck.enter_w ||
      '   where prest.nr_sequencia = a.nr_seq_prestador ' || pls_util_pck.enter_w ||
      '   and prest.cd_prestador = :cd_prestador ) ', dados_restricao_w);

    valor_bind_p := sql_pck.bind_variable(':cd_prestador', dados_filtro_p.cd_prestador, valor_bind_p);
  end if;

  -------------------------------------------- Dados da fatura ---------------------------------------------------

  if ((dados_filtro_p.nr_nota_cred_deb IS NOT NULL AND dados_filtro_p.nr_nota_cred_deb::text <> '') or
    (dados_filtro_p.nr_nota_cred_deb_reemb IS NOT NULL AND dados_filtro_p.nr_nota_cred_deb_reemb::text <> '') or
    (dados_filtro_p.cd_unimed_origem IS NOT NULL AND dados_filtro_p.cd_unimed_origem::text <> '') or
    (dados_filtro_p.nr_seq_fatura IS NOT NULL AND dados_filtro_p.nr_seq_fatura::text <> '')) then
    
    dados_restricao_w := pls_util_pck.sql_restricao(
        ' and exists (  select  1 ' || pls_util_pck.enter_w ||
        '   from  ptu_fatura fatura ' || pls_util_pck.enter_w ||
        '   where fatura.nr_sequencia = conta.nr_seq_fatura ', dados_restricao_w);

    -- Nota de cr?dito fatura

    if (dados_filtro_p.nr_nota_cred_deb IS NOT NULL AND dados_filtro_p.nr_nota_cred_deb::text <> '') then
    
      dados_restricao_w := pls_util_pck.sql_restricao('and fatura.nr_nota_credito_debito = :nr_nota_cred_deb', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_nota_cred_deb', dados_filtro_p.nr_nota_cred_deb, valor_bind_p);

    end if;

    -- Cr?dito d?bito Reembolso.

    if (dados_filtro_p.nr_nota_cred_deb_reemb IS NOT NULL AND dados_filtro_p.nr_nota_cred_deb_reemb::text <> '') then
    
      dados_restricao_w := pls_util_pck.sql_restricao('and fatura.nr_nota_credito_debito = :nr_nota_cred_deb_reemb', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_nota_cred_deb_reemb', dados_filtro_p.nr_nota_cred_deb_reemb, valor_bind_p);
    end if;

    -- Unimed de origem.

    if (dados_filtro_p.cd_unimed_origem IS NOT NULL AND dados_filtro_p.cd_unimed_origem::text <> '') then
      
      dados_restricao_w := pls_util_pck.sql_restricao('and fatura.cd_unimed_origem = :cd_unimed_origem', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':cd_unimed_origem', dados_filtro_p.cd_unimed_origem, valor_bind_p);
    end if;

    -- Fatura

    if (dados_filtro_p.nr_seq_fatura IS NOT NULL AND dados_filtro_p.nr_seq_fatura::text <> '') then

      dados_restricao_w := pls_util_pck.sql_restricao('and fatura.nr_fatura = :nr_seq_fatura', dados_restricao_w);
      valor_bind_p := sql_pck.bind_variable(':nr_seq_fatura', dados_filtro_p.nr_seq_fatura, valor_bind_p);
    end if;

    dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao || ')';
  end if;

  -------------------------------------------- Grupo de prestadores -------------------------------------------- 

  -- Se prestador pertence ao grupo  

  if (dados_filtro_p.nr_seq_grupo_prestador IS NOT NULL AND dados_filtro_p.nr_seq_grupo_prestador::text <> '') then
  
    dados_restricao_w := pls_util_pck.sql_tabela('table(pls_grupos_pck.obter_prestadores_grupo(:nr_seq_grupo_prestador))', 'prest_grupo', dados_restricao_w);
    
    dados_restricao_w := pls_util_pck.sql_restricao(
    ' and   prest_grupo.nr_seq_prestador = a.nr_seq_prestador ', dados_restricao_w);

    valor_bind_p := sql_pck.bind_variable(':nr_seq_grupo_prestador', dados_filtro_p.nr_seq_grupo_prestador, valor_bind_p);
  end if;

  -- obrigatoriamente precisa acessar toda a estrutura pelo motivo que aqui acessa os lotes

  dados_restricao_w := pls_analise_cta_pck.obter_tab_sel_busca_analise('pls_lote_protocolo_conta', ie_select_p, dados_restricao_w, dados_filtro_p);

  dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
      ' and lote.dt_geracao_analise is not null ' || pls_util_pck.enter_w ||
      ' and lote.ie_status =   ''A'' ';

  -- se for para executar comando para as an?lises de refer?ncia, retira fora o que j? foi inclu?do na tabela no select anterior de an?lises normais

  if (ie_select_p = 2) then
  
    dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
      ' and not exists (select  1' || pls_util_pck.enter_w || 
      '     from    pls_analise_conta_temp yz' || pls_util_pck.enter_w || 
      '     where   yz.nr_id_transacao = :nr_id_transacao' || pls_util_pck.enter_w || 
      '     and     yz.nr_sequencia = a.nr_sequencia)';

    valor_bind_p := sql_pck.bind_variable(':nr_id_transacao', nr_id_transacao_p, valor_bind_p);
  end if;

  if (dados_filtro_p.cd_condicao_pagamento IS NOT NULL AND dados_filtro_p.cd_condicao_pagamento::text <> '') then
    dados_restricao_w.ds_restricao := dados_restricao_w.ds_restricao || pls_util_pck.enter_w ||
      'and  exists( select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_conta y, ' || pls_util_pck.enter_w ||
      '     pls_prestador_pagto x ' || pls_util_pck.enter_w ||
      '   where y.nr_seq_protocolo = proto.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and x.nr_seq_prestador = y.nr_seq_prestador_exec ' || pls_util_pck.enter_w ||
      '   and proto.dt_mes_competencia between x.dt_inicio_vigencia_ref and dt_fim_vigencia_ref ' || pls_util_pck.enter_w ||
      '   and x.cd_condicao_pagamento = :cd_condicao_pagamento' || pls_util_pck.enter_w ||
      '   union all ' || pls_util_pck.enter_w ||
      '   select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_conta y, ' || pls_util_pck.enter_w ||
      '     pls_prestador_pagto x, ' || pls_util_pck.enter_w ||
      '     pls_conta_proc w, ' || pls_util_pck.enter_w ||
      '     pls_proc_participante z ' || pls_util_pck.enter_w ||
      '   where y.nr_seq_protocolo = proto.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and w.nr_seq_conta = y.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and z.nr_seq_conta_proc = w.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and x.nr_seq_prestador = nvl(z.nr_seq_prestador_pgto, z.nr_seq_prestador) ' || pls_util_pck.enter_w ||
      '   and proto.dt_mes_competencia between x.dt_inicio_vigencia_ref and dt_fim_vigencia_ref ' || pls_util_pck.enter_w ||
      '   and x.cd_condicao_pagamento = :cd_condicao_pagamento' || pls_util_pck.enter_w ||
      '   union all ' || pls_util_pck.enter_w ||
      '   select  1 ' || pls_util_pck.enter_w ||
      '   from  pls_conta y, ' || pls_util_pck.enter_w ||
      '     pls_prestador_pagto x, ' || pls_util_pck.enter_w ||
      '     pls_conta_medica_resumo z ' || pls_util_pck.enter_w ||
      '   where y.nr_seq_protocolo = proto.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and z.nr_seq_conta = y.nr_sequencia ' || pls_util_pck.enter_w ||
      '   and x.nr_seq_prestador = z.nr_seq_prestador_pgto ' || pls_util_pck.enter_w ||
      '   and proto.dt_mes_competencia between x.dt_inicio_vigencia_ref and dt_fim_vigencia_ref ' || pls_util_pck.enter_w ||
      '   and x.cd_condicao_pagamento = :cd_condicao_pagamento ' || pls_util_pck.enter_w ||
      ' )';

    valor_bind_p := sql_pck.bind_variable(':cd_condicao_pagamento', dados_filtro_p.cd_condicao_pagamento, valor_bind_p);
  end if;

  
end if;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_analise_cta_pck.obter_restr_busca_analise ( dados_filtro_p table_dados_busca_analise, ie_select_p integer, nr_id_transacao_p pls_analise_conta_temp.nr_id_transacao%type, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
