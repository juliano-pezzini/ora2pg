-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_divergencia_solic_ordem ( nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ds_divergencia_w			varchar(255);
ie_diverg_solic_ordem_w		varchar(1);
cd_estabelecimento_w		smallint;
ie_divergencia_w			varchar(1);
qt_material_w			double precision;
vl_unitario_material_w		double precision;
nr_item_oci_w			integer;
nr_solic_compra_w			bigint;
nr_item_solic_w			integer;
qt_divergencia_entrega_w		integer;
qt_divergencia_qt_entrega_w		integer;
qt_divergencia_total_item_w		integer;
qt_divergencia_valor_w		integer;

c01 CURSOR FOR 
SELECT	a.ie_divergencia 
from	regra_diverg_solic_ordem a 
where	a.cd_estabelecimento = cd_estabelecimento_w 
and	a.ie_situacao = 'A' 
and not exists ( 
	SELECT	1 
	from	ordem_divergencia_solic b 
	where	b.nr_ordem_compra = nr_ordem_compra_p 
	and	b.ie_divergencia = a.ie_divergencia);

c02 CURSOR FOR 
SELECT	nr_item_oci, 
	nr_solic_compra, 
	nr_item_solic_compra, 
	qt_material, 
	vl_unitario_material 
from	ordem_compra_item 
where	nr_ordem_compra = nr_ordem_compra_p 
and	(nr_solic_compra IS NOT NULL AND nr_solic_compra::text <> '');


BEGIN 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
begin 
select	ie_diverg_solic_ordem 
into STRICT	ie_diverg_solic_ordem_w 
from	parametro_compras 
where	cd_estabelecimento	= cd_estabelecimento_w;
exception when no_data_found then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265994);
	--'Não existe o cadastro do parametro do compras.' || chr(13) || 
	--'Verifique!' 
end;
 
if (ie_diverg_solic_ordem_w = 'S') then 
	begin 
 
	delete	from ordem_divergencia_solic 
	where	nr_ordem_compra = nr_ordem_compra_p 
	and	coalesce(ds_justificativa::text, '') = '';
 
	open C01;
	loop 
	fetch C01 into 
		ie_divergencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
 
		open C02;
		loop 
		fetch C02 into 
			nr_item_oci_w, 
			nr_solic_compra_w, 
			nr_item_solic_w, 
			qt_material_w, 
			vl_unitario_material_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			if (ie_divergencia_w = 0) then /*Data entrega*/
 
				select	count(*) 
				into STRICT	qt_divergencia_entrega_w 
				from	ordem_compra_item_entrega a 
				where	a.nr_ordem_compra	= nr_ordem_compra_p 
				and	a.nr_item_oci		= nr_item_oci_w 
				and not exists ( 
					SELECT	1 
					from	solic_compra_item_entrega b 
					where	b.nr_solic_compra		= nr_solic_compra_w 
					and	b.nr_item_solic_compra	= nr_item_solic_w 
					and	a.dt_prevista_entrega	= b.dt_entrega_solicitada);
 
				if (qt_divergencia_entrega_w > 0) then 
					insert into ordem_divergencia_solic( 
						nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_ordem_compra, 
						nr_item_oci, 
						ie_divergencia, 
						ds_justificativa) 
					values (nextval('ordem_divergencia_solic_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_ordem_compra_p, 
						nr_item_oci_w, 
						ie_divergencia_w, 
						'');
				end if;
 
			elsif (ie_divergencia_w = 1) then /*Quantidade de cada entrega*/
 
				select	count(*) 
				into STRICT	qt_divergencia_qt_entrega_w 
				from	ordem_compra_item_entrega a 
				where	a.nr_ordem_compra = nr_ordem_compra_p 
				and	a.nr_item_oci = nr_item_oci_w 
				and not exists ( 
					SELECT	1 
					from	solic_compra_item_entrega b 
					where	b.nr_solic_compra		= nr_solic_compra_w 
					and	b.nr_item_solic_compra	= nr_item_solic_w 
					and	a.dt_prevista_entrega	= b.dt_entrega_solicitada 
					and	a.qt_prevista_entrega	= b.qt_entrega_solicitada);
				if (qt_divergencia_qt_entrega_w > 0) then 
					insert into ordem_divergencia_solic( 
						nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_ordem_compra, 
						nr_item_oci, 
						ie_divergencia, 
						ds_justificativa) 
					values (nextval('ordem_divergencia_solic_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_ordem_compra_p, 
						nr_item_oci_w, 
						ie_divergencia_w, 
						'');
				end if;
 
			elsif (ie_divergencia_w = 2) then /*Quantidade total do item*/
 
				select	count(*) 
				into STRICT	qt_divergencia_total_item_w 
				from	solic_compra_item a 
				where	a.nr_solic_compra		= nr_solic_compra_w 
				and	a.nr_item_solic_compra	= nr_item_solic_w 
				and	a.qt_material			<> qt_material_w;
				if (qt_divergencia_total_item_w > 0) then 
					insert into ordem_divergencia_solic( 
						nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_ordem_compra, 
						nr_item_oci, 
						ie_divergencia, 
						ds_justificativa) 
					values (nextval('ordem_divergencia_solic_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_ordem_compra_p, 
						nr_item_oci_w, 
						ie_divergencia_w, 
						'');
				end if;	
					 
			elsif (ie_divergencia_w = 3) then /*Valor unitário*/
 
				select	count(*) 
				into STRICT	qt_divergencia_valor_w 
				from	solic_compra_item a 
				where	a.nr_solic_compra		= nr_solic_compra_w 
				and	a.nr_item_solic_compra	= nr_item_solic_w 
				and	a.vl_unit_previsto		<> vl_unitario_material_w;
				if (qt_divergencia_valor_w > 0) then 
					insert into ordem_divergencia_solic( 
						nr_sequencia, 
						dt_atualizacao, 
						nm_usuario, 
						dt_atualizacao_nrec, 
						nm_usuario_nrec, 
						nr_ordem_compra, 
						nr_item_oci, 
						ie_divergencia, 
						ds_justificativa) 
					values (nextval('ordem_divergencia_solic_seq'), 
						clock_timestamp(), 
						nm_usuario_p, 
						clock_timestamp(), 
						nm_usuario_p, 
						nr_ordem_compra_p, 
						nr_item_oci_w, 
						ie_divergencia_w, 
						'');
				end if;
			end if;
			end;
		end loop;
		close c02;
		end;
	end loop;
	close c01;
	end;
end if;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_divergencia_solic_ordem ( nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

