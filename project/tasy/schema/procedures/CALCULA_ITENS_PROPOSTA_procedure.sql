-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_itens_proposta ( nr_seq_proposta_p bigint, ie_orcam_coml_wheb_p text, vl_hora_cons_p bigint, vl_hora_cord_p bigint, nm_usuario_p text ) AS $body$
DECLARE


qt_hora_w		numeric(30);
ie_orcam_coml_wheb_w	varchar(5);
qt_tipo_item_w		bigint;


BEGIN

ie_orcam_coml_wheb_w := null;
if (ie_orcam_coml_wheb_p = 'S') then
	ie_orcam_coml_wheb_w :=	ie_orcam_coml_wheb_p;
end if;

-- Coordenação
select	count(*)
into STRICT	qt_tipo_item_w
from	com_cliente_prop_item
where	nr_seq_proposta = nr_seq_proposta_p
and	nr_seq_tipo_item = 4;

if (qt_tipo_item_w = 0) then

	select	sum(coalesce(qt_hora, 0))
	into STRICT	qt_hora_w
	from	com_cliente_prop_estim
	where	nr_seq_proposta = nr_seq_proposta_p
	and	nr_seq_mod_impl = 486;

	insert	into com_cliente_prop_item(
			nr_sequencia,
			nr_seq_proposta,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_seq_tipo_item,
			qt_item,
			vl_item,
			ie_orcam_coml_wheb,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			vl_unitario )
		values (nextval('com_cliente_prop_item_seq'),
			nr_seq_proposta_p,
			clock_timestamp(),
			nm_usuario_p,
			99,
			4,	-- Coordenação
			qt_hora_w,
			(qt_hora_w * vl_hora_cord_p),
			ie_orcam_coml_wheb_w,
			clock_timestamp(),
			nm_usuario_p,
			vl_hora_cord_p);
end if;


-- Implantação
select	count(*)
into STRICT	qt_tipo_item_w
from	com_cliente_prop_item
where	nr_seq_proposta = nr_seq_proposta_p
and	nr_seq_tipo_item = 2;

if (qt_tipo_item_w = 0) then

	select	sum(coalesce(qt_hora, 0))
	into STRICT	qt_hora_w
	from	com_cliente_prop_estim
	where	nr_seq_proposta = nr_seq_proposta_p
	and	nr_seq_mod_impl <> 486;

	insert	into com_cliente_prop_item(
			nr_sequencia,
			nr_seq_proposta,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apres,
			nr_seq_tipo_item,
			qt_item,
			vl_item,
			ie_orcam_coml_wheb,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			vl_unitario )
		values (nextval('com_cliente_prop_item_seq'),
			nr_seq_proposta_p,
			clock_timestamp(),
			nm_usuario_p,
			99,
			2,	-- Implantação
			qt_hora_w,
			(qt_hora_w * vl_hora_cons_p),
			ie_orcam_coml_wheb_w,
			clock_timestamp(),
			nm_usuario_p,
			vl_hora_cons_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_itens_proposta ( nr_seq_proposta_p bigint, ie_orcam_coml_wheb_p text, vl_hora_cons_p bigint, vl_hora_cord_p bigint, nm_usuario_p text ) FROM PUBLIC;
