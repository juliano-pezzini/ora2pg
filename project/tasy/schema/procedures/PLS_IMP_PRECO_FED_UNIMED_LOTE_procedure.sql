-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_preco_fed_unimed_lote (nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_linha_w			varchar(4000);

/* =================== CAMPOS ================== */

ds_erro_w			varchar(255);
cd_fornecedor_fed_sc_w		varchar(14);
cd_cgc_fornec_w			varchar(14);
ie_produto_w			varchar(1);
vl_soma_prod_fornec_w		bigint	:= 0;
vl_produto_w			double precision;
nr_seq_prestador_w		bigint;
nr_seq_material_w		bigint;
cd_fornecedor_fed_sc_ww		bigint;
vl_soma_valida_w		bigint;
nr_seq_mat_w			bigint;
qt_fornecedores_w		bigint;
qt_fornec_preco_w		bigint;
cd_material_w			bigint;
nr_seq_uni_fed_sc_preco_w	bigint;
cd_produto_w			bigint;
ie_possui_preco_w		bigint;
ie_possui_fornec_w		bigint;
ie_tipo_registro_w		integer;
ie_moeda_w			smallint;
dt_preco_w			timestamp;
ie_situacao_ant_w		varchar(1);
nr_seq_preco_mat_w		bigint;
sg_estado_w			varchar(2);

C01 CURSOR FOR
	SELECT	ds_conteudo
	from	w_import_mat_unimed
	order by
		nr_sequencia;


BEGIN
--Validação de arquivo selecionado para a Importação
begin
select	obter_se_somente_numero(substr(ds_conteudo,11,41))
into STRICT	ie_produto_w
from	w_import_mat_unimed
where	substr(ds_conteudo,7,1)	= 'D'  LIMIT 1;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(282595);
end;

if (ie_produto_w	= 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(188179);
else
	open C01;
	loop
	fetch C01 into
		ds_linha_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		-- DETALHE
		if (substr(ds_linha_w,7,1) = 'D') then
			cd_fornecedor_fed_sc_w	:= substr(ds_linha_w,19,10);
			vl_produto_w		:= (substr(ds_linha_w,29,10) || ',' || substr(ds_linha_w,39,2))::numeric;

			begin
			dt_preco_w		:= to_char(to_date(substr(ds_linha_w,41,8)),'dd/mm/yyyy');
			exception
			when others then
			dt_preco_w	:= null;
			end;

			select	CASE WHEN substr(ds_linha_w,49,3)=000 THEN 1  ELSE 1 END
			into STRICT	ie_moeda_w
			;

			cd_produto_w		:= substr(ds_linha_w,11,8);

			vl_soma_prod_fornec_w	:= vl_soma_prod_fornec_w + cd_fornecedor_fed_sc_w + substr(cd_produto_w,11,7);

			sg_estado_w		:= substr(ds_linha_w,52,2);

			select	max(nr_sequencia)
			into STRICT	nr_seq_mat_w
			from	pls_mat_unimed_fed_sc
			where	cd_material		= cd_produto_w;

			select	max(a.ie_situacao),
				max(a.nr_sequencia)
			into STRICT	ie_situacao_ant_w,
				nr_seq_preco_mat_w
			from	pls_mat_unimed_fed_sc b,
				pls_mat_uni_fed_sc_preco a
			where	a.nr_seq_mat_unimed	= b.nr_sequencia
			and	b.cd_material		= cd_produto_w
			and	a.dt_preco		= dt_preco_w
			and	a.cd_fornecedor_fed_sc	= cd_fornecedor_fed_sc_w;

			if (nr_seq_mat_w IS NOT NULL AND nr_seq_mat_w::text <> '') then
				insert into pls_mat_uni_sc_pre_imp(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_lote,
					nr_seq_mat_unimed,
					dt_preco,
					vl_preco,
					cd_cgc_forncedor,
					cd_moeda,
					cd_fornecedor_fed_sc,
					ie_situacao,
					ie_inconsistente,
					cd_material,
					ie_situacao_ant,
					nr_seq_preco,
					sg_estado)
				values (nextval('pls_mat_uni_sc_pre_imp_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_lote_p,
					nr_seq_mat_w,
					dt_preco_w,
					vl_produto_w,
					null,
					ie_moeda_w,
					cd_fornecedor_fed_sc_w,
					'A',
					'N',
					cd_produto_w,
					ie_situacao_ant_w,
					nr_seq_preco_mat_w,
					sg_estado_w);
			end if;
		--TRAILER
		elsif (substr(ds_linha_w,7,1) = 'T') then
			vl_soma_valida_w	:= substr(ds_linha_w,8,16);
			-- Verifica se a somatória dos códigos dos (produtos + fornecedores) é igual a informada no trailer do arquivo. Se for diferente, exibe a mensagem.
			if (vl_soma_prod_fornec_w <> vl_soma_valida_w) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(188181);
			end if;
		end if;

		end;
	end loop;
	close C01;
end if;
--Anteriormente fazia o insert de todos os materiais da federação na tabela imp, mesmo os que não vem mais no arquivo
--Removido pois não foi identificado nenhuma utilizade desses registros na tabela imp, já que ao atualizar os preços, apenas
--os casos com dt_preco diferente é que serão inseridos na tabela PLS_MAT_UNIMED_FED_SC
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_preco_fed_unimed_lote (nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
