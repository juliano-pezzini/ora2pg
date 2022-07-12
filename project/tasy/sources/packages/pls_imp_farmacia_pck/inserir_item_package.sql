-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_farmacia_pck.inserir_item ( nr_seq_conta_p pls_conta.nr_sequencia%type, ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


ie_tipo_despesa_w   pls_conta_mat.ie_tipo_despesa%type;
ds_dt_data_doc_w  varchar(8);
dt_data_doc_w    timestamp;
ds_vl_total_w    varchar(13);
qt_item_w      pls_conta_mat.qt_material%type;
vl_total_w      pls_conta_mat.vl_material%type;
vl_unitario_w    pls_conta_mat.vl_unitario%type;
cd_ean_w      varchar(13);
nr_seq_mat_w    pls_material.nr_sequencia%type;
nr_seq_conta_mat_w  pls_conta_mat.nr_sequencia%type;
ie_tipo_transacao_w  pls_conta_mat_regra.ie_tp_transacao%type;


BEGIN

  ie_tipo_despesa_w  :=   substr(ds_conteudo_p, 11, 1);
  ie_tipo_transacao_w := substr(ds_conteudo_p, 12, 2);
  ds_dt_data_doc_w  :=  substr(ds_conteudo_p, 30, 8);
  ds_vl_total_w    :=  substr(ds_conteudo_p, 38, 13);
  qt_item_w      :=  substr(ds_conteudo_p, 59, 5);
  cd_ean_w      :=  substr(ds_conteudo_p, 81, 13);

  nr_seq_mat_w := pls_imp_farmacia_pck.obter_seq_material(cd_ean_w);

  select   (replace(substr(ds_vl_total_w,1,11),'.',''))::numeric  + ((substr(ds_vl_total_w,12,2)/100)::numeric )
  into STRICT  vl_total_w
;

  begin
    dt_data_doc_w := to_date(ds_dt_data_doc_w, 'YYYY/MM/DD');
  exception
  when others then
    dt_data_doc_w := clock_timestamp();
  end;

  vl_unitario_w := dividir(vl_total_w, qt_item_w);

  insert into pls_conta_mat(nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
                ie_situacao, ie_status, nm_usuario,
                nm_usuario_nrec, dt_atendimento, qt_material_imp,
                vl_material_imp, vl_unitario_imp, nr_seq_conta,
                nr_seq_material, cd_material_imp, vl_material,
        ie_tipo_despesa)
  values (  nextval('pls_conta_mat_seq'), clock_timestamp(), clock_timestamp(),
    'I', 'U',  nm_usuario_p,
    nm_usuario_p, dt_data_doc_w, qt_item_w,
    vl_total_w, vl_unitario_w, nr_seq_conta_p,
    nr_seq_mat_w, cd_ean_w, vl_total_w,
    ie_tipo_despesa_w)  returning nr_sequencia into nr_seq_conta_mat_w;

  CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_mat(nr_seq_conta_mat_w, nm_usuario_p);

  update pls_conta_mat_regra
  set	ie_tp_transacao = coalesce(trim(both ie_tipo_transacao_w),'00')
  where	nr_sequencia = nr_seq_conta_mat_w;

null;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_farmacia_pck.inserir_item ( nr_seq_conta_p pls_conta.nr_sequencia%type, ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;