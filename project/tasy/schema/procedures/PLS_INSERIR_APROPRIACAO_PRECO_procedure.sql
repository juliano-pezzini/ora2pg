-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_apropriacao_preco (ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type, nr_seq_item_mens_p pls_mensalidade_seg_item.nr_sequencia%type, nr_seq_segurado_preco_p pls_segurado_preco.nr_sequencia%type, vl_item_p pls_mensalidade_seg_item.vl_item%type, vl_reajuste_p bigint, tx_proporcional_1a_mens_p bigint, tx_proporcional_rescisao_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_valor_apropriado_w		varchar(1) := 'N';
qt_apropriacao_w		integer;
vl_apropriacao_w		pls_segurado_preco_aprop.vl_apropriacao%type;
vl_apropriado_w			pls_segurado_preco_aprop.vl_apropriacao%type;
vl_total_apropriado_w		double precision := 0;

C01 CURSOR(	nr_seq_segurado_preco_pc	pls_segurado_preco.nr_sequencia%type) FOR
	SELECT	a.nr_seq_centro_apropriacao 	nr_seq_centro_apropriacao,
		a.vl_apropriacao 		vl_apropriacao,
		a.vl_reajuste 			vl_reajuste,
		a.vl_base_reajuste 		vl_base_reajuste,
		b.dt_reajuste 			dt_reajuste,
		b.nr_seq_segurado 		nr_seq_segurado,
		b.nr_seq_preco			nr_seq_preco
	from	pls_segurado_preco_aprop a,
		pls_segurado_preco 	 b
	where	a.nr_seq_segurado_preco = b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_segurado_preco_pc;

BEGIN
select	count(1)
into STRICT	qt_apropriacao_w
from	pls_segurado_preco_aprop
where	nr_seq_segurado_preco	= nr_seq_segurado_preco_p;

for r_c01_w in C01(nr_seq_segurado_preco_p) loop
	begin
	/* Se o tipo do item for reajuste, busca o valor de reajuste já calculado da apropriação. */

	if (ie_tipo_item_p in ('4', '5', '25', '35')) then
		vl_apropriacao_w := coalesce(r_c01_w.vl_reajuste, 0);

		if	((ie_tipo_item_p = 25) and (coalesce(vl_apropriacao_w,0) = 0)) then
			if (qt_apropriacao_w = 1) then
				vl_apropriacao_w := vl_item_p;
			elsif (qt_apropriacao_w > 1) then
				vl_apropriacao_w := pls_obter_valor_apropriacao(r_c01_w.nr_seq_segurado,r_c01_w.dt_reajuste,r_c01_w.nr_seq_preco,r_c01_w.nr_seq_centro_apropriacao,vl_item_p);
			end if;
		end if;
	elsif (coalesce(vl_reajuste_p,0) <> 0) then /* Se for pré-estabelecido e possuir valor de reajuste nesta mensalidade, obtem o valor antigo do pré estabelecido */
		vl_apropriacao_w := r_c01_w.vl_base_reajuste;

		if (coalesce(vl_apropriacao_w,0) = 0) then
			vl_apropriacao_w := (r_c01_w.vl_apropriacao - vl_reajuste_p);
		end if;
	else
		vl_apropriacao_w := r_c01_w.vl_apropriacao;
	end if;

	if (vl_apropriacao_w <> 0) then
		/* Calcula o valor proporicionalmente caso for primeira ou última mensalidade do beneficiário. */

		if (tx_proporcional_1a_mens_p <> 0) then
			vl_apropriacao_w := vl_apropriacao_w * tx_proporcional_1a_mens_p;
		elsif (tx_proporcional_rescisao_p <> 0) then
			vl_apropriacao_w := vl_apropriacao_w * tx_proporcional_rescisao_p;
		end if;

		vl_total_apropriado_w := vl_total_apropriado_w + vl_apropriacao_w;

		/* Realiza o arredondamento da apropriação. */

		if (C01%rowcount = qt_apropriacao_w) then
			if (vl_total_apropriado_w <> vl_item_p) then
				vl_apropriacao_w := vl_apropriacao_w + (vl_item_p - vl_total_apropriado_w);
			end if;
		end if;

			insert into pls_mens_seg_item_aprop(	nr_sequencia,
						nr_seq_item,
						nr_seq_centro_apropriacao,
						vl_apropriacao,
						nm_usuario,
						nm_usuario_nrec,
						dt_atualizacao,
						dt_atualizacao_nrec)
			values (	nextval('pls_mens_seg_item_aprop_seq'),
						nr_seq_item_mens_p,
						r_c01_w.nr_seq_centro_apropriacao,
						vl_apropriacao_w,
						nm_usuario_p,
						nm_usuario_p,
						clock_timestamp(),
						clock_timestamp());

		ie_valor_apropriado_w := 'S';
	end if;
	end;
end loop;

if (ie_valor_apropriado_w	= 'S') then
	update	pls_mensalidade_seg_item
	set	ie_valor_apropriado	= 'S'
	where	nr_sequencia		= nr_seq_item_mens_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_apropriacao_preco (ie_tipo_item_p pls_mensalidade_seg_item.ie_tipo_item%type, nr_seq_item_mens_p pls_mensalidade_seg_item.nr_sequencia%type, nr_seq_segurado_preco_p pls_segurado_preco.nr_sequencia%type, vl_item_p pls_mensalidade_seg_item.vl_item%type, vl_reajuste_p bigint, tx_proporcional_1a_mens_p bigint, tx_proporcional_rescisao_p bigint, nm_usuario_p text) FROM PUBLIC;
