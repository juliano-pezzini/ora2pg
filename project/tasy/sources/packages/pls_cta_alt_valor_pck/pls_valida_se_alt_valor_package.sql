-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_cta_alt_valor_pck.pls_valida_se_alt_valor ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_p bigint) RETURNS varchar AS $body$
DECLARE

ie_valido_w    varchar(1)  := 'N';
ie_tipo_item_w    varchar(1);
vl_calculado_w    pls_conta_proc.vl_procedimento%type;
vl_apresentado_w  pls_conta_proc.vl_procedimento_imp%type;
ds_observacao_w    varchar(500);
qt_item_w    pls_conta_proc_v.qt_procedimento%type;
BEGIN

for r_C_itens_analise_w in current_setting('pls_cta_alt_valor_pck.c_itens_analise')::CURSOR((nr_seq_analise_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, nm_usuario_p, nr_id_transacao_p) loop

  ie_tipo_item_w  := pls_util_cta_pck.pls_obter_tipo_item_atend(null, r_C_itens_analise_w.nr_seq_conta_proc, r_C_itens_analise_w.nr_seq_conta_mat, null);
  -- Se for procedimento, buscar as informa??es do mesmo
  if (ie_tipo_item_w = 'P')  then
    select  vl_procedimento_imp,
      vl_procedimento,
      qt_procedimento
    into STRICT  vl_apresentado_w,
      vl_calculado_w,
      qt_item_w
    from   pls_conta_proc_v
    where  nr_sequencia = r_C_itens_analise_w.nr_seq_conta_proc;

  elsif (ie_tipo_item_w = 'M')  then
    select   vl_material_imp,
      vl_material,
      qt_material
    into STRICT  vl_apresentado_w,
      vl_calculado_w,
      qt_item_w
    from  pls_conta_mat_v
    where  nr_sequencia = r_C_itens_analise_w.nr_seq_conta_mat;
  end if;
  /*Verificar por a??o se o valor est? zerado, se o valor que estiver sendo aceito estiver zerado
  deve gravar log do mesmo e depois apresentar pro usuario*/
  --Aceitar valor calculado
  case  cd_acao_analise_p
    when 1 then
      if (vl_apresentado_w = 0)  and (vl_calculado_w = 0)  then
        ie_valido_w  := 'S';
      end if;
    when 2 then
      if (vl_apresentado_w = 0)  and (vl_calculado_w = 0)  then
        ie_valido_w  := 'S';
      end if;
    when 3 then
      if (vl_calculado_w  = 0)  then
        ie_valido_w  := 'S';
      end if;
  --Aceitar valor apresentado
    when 4 then
      if (vl_apresentado_w = 0)  then
        ie_valido_w  := 'S';
      end if;
  --Aceitar melhor valor
    when 5 then
      if (vl_apresentado_w = 0)  and (vl_calculado_w = 0)  then
        ie_valido_w  := 'S';
      end if;
  end case;

  if (ie_valido_w  = 'S')  then
    if (ie_tipo_item_w  = 'P')  then
      ds_observacao_w  := substr(  ds_observacao_w || r_C_itens_analise_w.nr_seq_conta_proc || ' ' ||
              pls_obter_dados_conta_proc(r_C_itens_analise_w.nr_seq_conta_proc, 'D'), 1, 255) ||
              pls_util_pck.enter_w;
    elsif (ie_tipo_item_w = 'M')  then
      ds_observacao_w  := substr(  ds_observacao_w || r_C_itens_analise_w.nr_seq_conta_mat || ' ' ||
              pls_obter_dados_conta_mat(r_C_itens_analise_w.nr_seq_conta_mat, 'D'), 1, 255) ||
              pls_util_pck.enter_w;
    end if;
  end if;
end loop;

return  ds_observacao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_cta_alt_valor_pck.pls_valida_se_alt_valor ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type, nr_id_transacao_p bigint) FROM PUBLIC;