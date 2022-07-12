-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_regra_qtd_execucao_pck.pls_obter_restr_qtd_execucao ( dados_regra_p pls_regra_qtd_execucao_pck.dados_regra, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Esta function é responsável por obter as restrições para aplicação das regras de quantidade de execução dos procedimentos.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_restricao_w  varchar(2000);


BEGIN

ds_restricao_w := null;

if (dados_regra_p.ie_origem_protocolo IS NOT NULL AND dados_regra_p.ie_origem_protocolo::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.ie_origem_protocolo = :ie_origem_protocolo ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_origem_protocolo', dados_regra_p.ie_origem_protocolo, valor_bind_p);
end if;

-- procedimento
if (dados_regra_p.nr_seq_conta_proc IS NOT NULL AND dados_regra_p.nr_seq_conta_proc::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_sequencia = :nr_seq_conta_proc ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_conta_proc', dados_regra_p.nr_seq_conta_proc, valor_bind_p);
end if;

-- conta
if (dados_regra_p.nr_seq_conta IS NOT NULL AND dados_regra_p.nr_seq_conta::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_seq_conta = :nr_seq_conta ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_conta', dados_regra_p.nr_seq_conta, valor_bind_p);
end if;

-- protocolo
if (dados_regra_p.nr_seq_protocolo IS NOT NULL AND dados_regra_p.nr_seq_protocolo::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_seq_protocolo = :nr_seq_protocolo ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_protocolo', dados_regra_p.nr_seq_protocolo, valor_bind_p);
end if;

-- lote ao qual pertence o protocolo
if (dados_regra_p.nr_seq_lote IS NOT NULL AND dados_regra_p.nr_seq_lote::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_seq_lote_conta = :nr_seq_lote ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_lote', dados_regra_p.nr_seq_lote, valor_bind_p);
end if;

-- análise
if (dados_regra_p.nr_seq_analise IS NOT NULL AND dados_regra_p.nr_seq_analise::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_seq_analise = :nr_seq_analise ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_analise', dados_regra_p.nr_seq_analise, valor_bind_p);
end if;

-- filtragem pelo procedimento propriamente dito
if (dados_regra_p.cd_procedimento IS NOT NULL AND dados_regra_p.cd_procedimento::text <> '') then

  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.ie_origem_proced = :ie_origem_proced ' || pls_util_pck.enter_w ||
                    ' and a.cd_procedimento = :cd_procedimento ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_origem_proced', dados_regra_p.ie_origem_proced, valor_bind_p);
  valor_bind_p := sql_pck.bind_variable(  ':cd_procedimento', dados_regra_p.cd_procedimento, valor_bind_p);
end if;

-- grupo de procedimento
if (dados_regra_p.cd_grupo_proc IS NOT NULL AND dados_regra_p.cd_grupo_proc::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.cd_grupo_proc = :cd_grupo_proc ';

  valor_bind_p := sql_pck.bind_variable(  ':cd_grupo_proc', dados_regra_p.cd_grupo_proc, valor_bind_p);
end if;

-- especialidade do procedimento
if (dados_regra_p.cd_especialidade IS NOT NULL AND dados_regra_p.cd_especialidade::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.cd_especialidade = :cd_especialidade ';

  valor_bind_p := sql_pck.bind_variable(  ':cd_especialidade', dados_regra_p.cd_especialidade, valor_bind_p);
end if;

-- área do procedimento
if (dados_regra_p.cd_area_procedimento IS NOT NULL AND dados_regra_p.cd_area_procedimento::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.cd_area_procedimento = :cd_area_procedimento ';

  valor_bind_p := sql_pck.bind_variable(  ':cd_area_procedimento', dados_regra_p.cd_area_procedimento, valor_bind_p);
end if;

-- grupo de serviço do procedimento
if (dados_regra_p.nr_seq_grupo_servico IS NOT NULL AND dados_regra_p.nr_seq_grupo_servico::text <> '') then

  if (pls_util_cta_pck.usar_novo_agrup = 'S') then
    ds_restricao_w := ds_restricao_w   || pls_util_pck.enter_w ||
      '  and  exists (select  1 ' || pls_util_pck.enter_w ||
      '      from  pls_grupo_servico_tm grupox ' || pls_util_pck.enter_w ||
      '      where  grupox.nr_seq_grupo_servico = :nr_seq_grupo_servico' || pls_util_pck.enter_w ||
      '      and  grupox.ie_origem_proced = a.ie_origem_proced' || pls_util_pck.enter_w ||
      '      and  grupox.cd_procedimento = a.cd_procedimento' || pls_util_pck.enter_w ||
      '  )';
  else
    ds_restricao_w := ds_restricao_w   || pls_util_pck.enter_w ||
      '  and  (select  count(1) ' || pls_util_pck.enter_w ||
      '  from  table(pls_grupos_pck.obter_procs_grupo_servico(:nr_seq_grupo_servico,a.ie_origem_proced ,a.cd_procedimento )) grupox ' || pls_util_pck.enter_w ||
      '  ) > 0 ';
  end if;

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_grupo_servico', dados_regra_p.nr_seq_grupo_servico, valor_bind_p);
end if;

-- grupo de prestador
if (dados_regra_p.nr_seq_grupo_prestador IS NOT NULL AND dados_regra_p.nr_seq_grupo_prestador::text <> '') then
  ds_restricao_w := ds_restricao_w  || pls_util_pck.enter_w ||
    ' and exists (  select  1 '  || pls_util_pck.enter_w ||
    '    from  pls_grup_prest_preco_v grup_prest       '|| pls_util_pck.enter_w ||
    '    where  grup_prest.nr_seq_grupo = :nr_seq_grupo_prestador   '|| pls_util_pck.enter_w ||
    '    and  grup_prest.nr_seq_prestador = a.nr_seq_prestador_exec ) ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_grupo_prestador', dados_regra_p.nr_seq_grupo_prestador, valor_bind_p);
end if;

-- sequencia do prestador
if (dados_regra_p.nr_seq_prestador IS NOT NULL AND dados_regra_p.nr_seq_prestador::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.nr_seq_prestador_exec = :nr_seq_prestador ';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_prestador', dados_regra_p.nr_seq_prestador, valor_bind_p);
end if;

-- tipo de guia da conta
if (dados_regra_p.ie_tipo_guia IS NOT NULL AND dados_regra_p.ie_tipo_guia::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.ie_tipo_guia = :ie_tipo_guia ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_tipo_guia', dados_regra_p.ie_tipo_guia, valor_bind_p);
end if;

-- tipo de conta
if (dados_regra_p.ie_tipo_conta IS NOT NULL AND dados_regra_p.ie_tipo_conta::text <> '') then

  -- se for T não precisa filtrar nada, é tudo
  if (dados_regra_p.ie_tipo_conta != 'T') then

    if (dados_regra_p.ie_tipo_conta = 'O') then
      ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.ie_tipo_conta in (''O'',''C'') ';
    else
      ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and (:ie_tipo_conta = a.ie_tipo_conta) ';

      valor_bind_p := sql_pck.bind_variable(  ':ie_tipo_conta', dados_regra_p.ie_tipo_conta, valor_bind_p);
    end if;
  end if;
end if;

-- edição AMB
if (dados_regra_p.cd_edicao_amb IS NOT NULL AND dados_regra_p.cd_edicao_amb::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w ||
    ' and exists (   select  1           ' || pls_util_pck.enter_w ||
    '          from  pls_regra_preco_proc  x    ' || pls_util_pck.enter_w ||
    '    where  x.nr_sequencia   = a.nr_seq_regra  ' || pls_util_pck.enter_w ||
    '    and  x.cd_edicao_amb = :cd_edicao_amb )  ';

  valor_bind_p := sql_pck.bind_variable(  ':cd_edicao_amb', dados_regra_p.cd_edicao_amb, valor_bind_p);
end if;

-- tipo do prestador
if (dados_regra_p.nr_seq_tipo_prestador IS NOT NULL AND dados_regra_p.nr_seq_tipo_prestador::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w ||
    ' and exists (  select  1' || pls_util_pck.enter_w ||
    '    from  pls_prestador  x' || pls_util_pck.enter_w ||
    '    where  x.nr_sequencia = a.nr_seq_prestador_exec' || pls_util_pck.enter_w ||
    '    and   x.nr_seq_tipo_prestador = :nr_seq_tipo_prestador)';

  valor_bind_p := sql_pck.bind_variable(  ':nr_seq_tipo_prestador', dados_regra_p.nr_seq_tipo_prestador, valor_bind_p);
end if;

-- tratamento para as vigências das regras
if (dados_regra_p.dt_inicio_vigencia IS NOT NULL AND dados_regra_p.dt_inicio_vigencia::text <> '' AND dados_regra_p.dt_fim_vigencia IS NOT NULL AND dados_regra_p.dt_fim_vigencia::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w ||
      ' and a.dt_procedimento  between :dt_inicio_vigencia and :dt_fim_vigencia';

  valor_bind_p := sql_pck.bind_variable(  ':dt_inicio_vigencia', dados_regra_p.dt_inicio_vigencia, valor_bind_p);
  valor_bind_p := sql_pck.bind_variable(  ':dt_fim_vigencia', dados_regra_p.dt_fim_vigencia, valor_bind_p);
else
  -- tratamento apenas para o início de vigência
  if (dados_regra_p.dt_inicio_vigencia IS NOT NULL AND dados_regra_p.dt_inicio_vigencia::text <> '') then
    ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.dt_procedimento >= :dt_inicio_vigencia ';

    valor_bind_p := sql_pck.bind_variable(  ':dt_inicio_vigencia', dados_regra_p.dt_inicio_vigencia, valor_bind_p);
  end if;

  -- tratamento apenas para o fim de vigência
  if (dados_regra_p.dt_fim_vigencia IS NOT NULL AND dados_regra_p.dt_fim_vigencia::text <> '') then
    ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.dt_procedimento <= :dt_fim_vigencia';

    valor_bind_p := sql_pck.bind_variable(  ':dt_fim_vigencia', dados_regra_p.dt_fim_vigencia, valor_bind_p);
  end if;
end if;

--formação do preco
if (dados_regra_p.ie_preco IS NOT NULL AND dados_regra_p.ie_preco::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w ||
    ' and exists (  select  1              '|| pls_util_pck.enter_w ||
    '    from  pls_plano x    ' || pls_util_pck.enter_w ||
    '      pls_segurado y ' || pls_util_pck.enter_w ||
    '    where  x.nr_sequencia   = y.nr_seq_plano  ' || pls_util_pck.enter_w ||
    '    and  y.nr_sequencia  = a.nr_seq_segurado ' || pls_util_pck.enter_w ||
    '    and  x.ie_preco    = :ie_preco )     ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_preco', dados_regra_p.ie_preco, valor_bind_p);
end if;

-- Via de acesso
if (dados_regra_p.ie_via_acesso IS NOT NULL AND dados_regra_p.ie_via_acesso::text <> '') then
  ds_restricao_w :=   ds_restricao_w || pls_util_pck.enter_w ||
      '  and nvl(a.ie_via_acesso,''U'') = :ie_via_acesso ';
  valor_bind_p := sql_pck.bind_variable(  ':ie_via_acesso', dados_regra_p.ie_via_acesso, valor_bind_p);
end if;

-- Tipo beneficiário
if (dados_regra_p.ie_tipo_segurado IS NOT NULL AND dados_regra_p.ie_tipo_segurado::text <> '') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || ' and a.ie_tipo_segurado = :ie_tipo_segurado ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_tipo_segurado', dados_regra_p.ie_tipo_segurado, valor_bind_p);
end if;

-- Tipo apresentação
if (dados_regra_p.ie_apresentacao IS NOT NULL AND dados_regra_p.ie_apresentacao::text <> '') then
-- se for T não precisa filtrar nada, é tudo
  if (dados_regra_p.ie_apresentacao != 'T') then
  ds_restricao_w := ds_restricao_w || pls_util_pck.enter_w || 'and a.ie_apresentacao = :ie_apresentacao ';

  valor_bind_p := sql_pck.bind_variable(  ':ie_apresentacao', dados_regra_p.ie_apresentacao, valor_bind_p);
  end if;
end if;


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_regra_qtd_execucao_pck.pls_obter_restr_qtd_execucao ( dados_regra_p pls_regra_qtd_execucao_pck.dados_regra, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;