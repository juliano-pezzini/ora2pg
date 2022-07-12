-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sap_fin_customer_pck.get_fee_items ( nr_seq_fila_p bigint) RETURNS SETOF T_GET_FEE_ITEMS AS $body$
DECLARE


nr_seq_documento_w		intpd_fila_transmissao.nr_seq_documento%type;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w	intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w				intpd_eventos_sistema.nr_seq_regra_conv%type;
r_get_fee_items_w			r_get_fee_items;
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
nr_seq_episodio_w			atendimento_paciente.nr_seq_episodio%type;
nr_item_trib_w        r_get_fee_items_w.strkt%type;
cd_conta_contabil_w      conta_contabil.cd_conta_contabil%type;
credit_indicator_w    r_get_fee_items_w.shkzg%type;
cd_estabelecimento_w  repasse_terceiro.cd_estabelecimento%type;
vl_imposto            repasse_terceiro_tributo.vl_imposto%type;

C01 CURSOR FOR
	SELECT	cd_material,
			vl_repasse,
			nr_atendimento,
      cd_conta_contabil,
      cd_centro_custo,
      substr(ds_observacao, 0, 50) ds_observacao,
      nr_repasse_terceiro
	from	repasse_terceiro_item
	where	nr_repasse_terceiro =	nr_seq_documento_w;
c01_w	c01%rowtype;


BEGIN
intpd_reg_integracao_inicio(nr_seq_fila_p, 'E', reg_integracao_w);

select	a.nr_seq_documento,
		coalesce(b.ie_conversao,'I'),
		b.nr_seq_sistema,
		b.nr_seq_projeto_xml,
		b.nr_seq_regra_conv
into STRICT	nr_seq_documento_w,
		ie_conversao_w,
		nr_seq_sistema_w,
		nr_seq_projeto_xml_w,
		nr_seq_regra_w
from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and		a.nr_sequencia = nr_seq_fila_p;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		r_get_fee_items_w				:=	null;
		reg_integracao_w.nm_tabela 		:=	'REPASSE_TERCEIRO_ITEM';
		reg_integracao_w.nm_elemento	:=	'Z_FI_KRED_HON_KIS';

		begin
		select	obter_episodio_atendimento(c01_w.nr_atendimento)
		into STRICT	nr_seq_episodio_w
		;
		exception
		when others then
			nr_seq_episodio_w		:=	null;
		end;

    begin
      select a.cd_estabelecimento 
        into STRICT cd_estabelecimento_w
        from repasse_terceiro a
       where a.nr_repasse_terceiro = c01_w.nr_repasse_terceiro;
    exception
		when others then
			cd_estabelecimento_w		:=	null;
		end;

    begin
      select max('X'), sum(a.vl_imposto)
        into STRICT nr_item_trib_w,
             vl_imposto
        from repasse_terceiro_tributo a
       where a.nr_repasse_terceiro = c01_w.nr_repasse_terceiro;
    exception
    when others then
			nr_item_trib_w		:= null;
      vl_imposto        := null;
		end;

    begin
      select cd_conta_contabil
        into STRICT cd_conta_contabil_w
        from conta_contabil a
       where a.cd_conta_contabil = c01_w.cd_conta_contabil;
    exception
    when others then
			cd_conta_contabil_w		:=	null;
		end;
    
    begin
      select CASE WHEN obter_dados_conta_contabil(cd_conta_contabil_w, cd_estabelecimento_w, 'DC')='D' THEN  'S'  ELSE 'H' END 
        into STRICT credit_indicator_w
;
    exception
    when others then
			credit_indicator_w :=	null;
		end;

		intpd_processar_atrib_envio(reg_integracao_w, 'NR_SEQ_EPISODIO', 'FALLTXT', 'N', nr_seq_episodio_w, 'N', r_get_fee_items_w.falltxt);
		--intpd_processar_atrib_envio(reg_integracao_w, 'X','KOART', 'N', 'c02_w.', 'N', r_get_fee_items_w.koart);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_MATERIAL', 'KTONR', 'N', c01_w.cd_material, 'N', r_get_fee_items_w.ktonr);
		intpd_processar_atrib_envio(reg_integracao_w, 'X','SHKZG', 'N', credit_indicator_w, 'N', r_get_fee_items_w.shkzg);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CONTA_CONTABIL','HKONT', 'N', c01_w.cd_conta_contabil, 'N', r_get_fee_items_w.hkont);
		intpd_processar_atrib_envio(reg_integracao_w, 'VL_REPASSE', 'BETRAG', 'N', c01_w.vl_repasse, 'N', r_get_fee_items_w.betrag);
		--intpd_processar_atrib_envio(reg_integracao_w, 'VL_IMPOSTO','MWSKZ', 'N', vl_imposto, 'N', r_get_fee_items_w.mwskz);
		intpd_processar_atrib_envio(reg_integracao_w, 'X','STRKT', 'N', nr_item_trib_w, 'N', r_get_fee_items_w.strkt);
		intpd_processar_atrib_envio(reg_integracao_w, 'CD_CENTRO_CUSTO','KOSTL', 'N', c01_w.cd_centro_custo, 'N', r_get_fee_items_w.kostl);
		intpd_processar_atrib_envio(reg_integracao_w, 'DS_OBSERVACAO','POSTXT', 'N', c01_w.ds_observacao, 'N', r_get_fee_items_w.postxt);

		RETURN NEXT r_get_fee_items_w;

	end;
end loop;
close C01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sap_fin_customer_pck.get_fee_items ( nr_seq_fila_p bigint) FROM PUBLIC;