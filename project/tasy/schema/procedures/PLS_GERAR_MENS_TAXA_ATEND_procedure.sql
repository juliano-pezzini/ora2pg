-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mens_taxa_atend ( nr_seq_mensalidade_seg_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_val_atend_w	pls_conta_val_atend.nr_sequencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
dt_mesano_referencia_w		timestamp;
ds_observacao_w			pls_mensalidade_seg_item.ds_observacao%type;
vl_item_w			pls_conta_val_atend.vl_liberado%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_protocolo_w		pls_protocolo_conta.nr_sequencia%type;
dt_competencia_mens_w		pls_conta_val_atend.dt_competencia_mens%type;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_conta,
		nr_seq_protocolo,
		dt_competencia_mens,
		vl_liberado
	from	pls_conta_val_atend
	where	dt_competencia_mens 	= dt_mesano_referencia_w
	and	nr_seq_segurado 	= nr_seq_segurado_w
	and	ie_cobrar_mensalidade	= 'S'
	and	coalesce(nr_seq_mensalidade_seg::text, '') = '';


BEGIN

nr_seq_segurado_w		:= pls_store_data_mens_pck.get_nr_seq_segurado;
dt_mesano_referencia_w		:= pls_store_data_mens_pck.get_dt_mesano_referencia;

ds_observacao_w := wheb_mensagem_pck.get_texto(334443,null);

open C01;
loop
fetch C01 into
	nr_seq_conta_val_atend_w,
	nr_seq_conta_w,
	nr_seq_protocolo_w,
	dt_competencia_mens_w,
	vl_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if	((coalesce(dt_competencia_mens_w::text, '') = '') or (dt_competencia_mens_w = dt_mesano_referencia_w)) then

		nr_seq_item_mensalidade_w := null;

		nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('38', nm_usuario_p, null, null, ds_observacao_w, null, null, null, null, 'N', null, null, null, null, nr_seq_conta_w, null, null, nr_seq_mensalidade_seg_p, null, null, null, nr_seq_protocolo_w, null, null, null, null, null, null, null, null, null, vl_item_w, nr_seq_item_mensalidade_w);

		if (nr_seq_item_mensalidade_w IS NOT NULL AND nr_seq_item_mensalidade_w::text <> '') then
			update	pls_conta_val_atend
			set	nr_seq_mensalidade_seg = nr_seq_mensalidade_seg_p
			where	nr_sequencia = nr_seq_conta_val_atend_w;
		end if;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mens_taxa_atend ( nr_seq_mensalidade_seg_p bigint, nm_usuario_p text) FROM PUBLIC;

