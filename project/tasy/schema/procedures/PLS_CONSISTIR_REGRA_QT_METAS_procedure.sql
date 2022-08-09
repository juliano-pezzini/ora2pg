-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_regra_qt_metas ( nr_seq_vend_meta_seq_p bigint, nr_seq_meta_regra_p bigint, qt_metas_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_meta_maximo_w	bigint;
qt_meta_atual_w		bigint;
qt_metas_novas_w	bigint;
qt_metas_total_w	bigint;


BEGIN

qt_metas_novas_w	:= qt_metas_p;

select	max(qt_meta)
into STRICT	qt_meta_maximo_w
from	pls_vendedor_meta
where	nr_sequencia = nr_seq_vend_meta_seq_p;

if (coalesce(qt_meta_maximo_w::text, '') = '') then
	qt_meta_maximo_w := 0;
end if;

if (qt_meta_maximo_w <> 0) then
	select	sum(qt_meta)
	into STRICT	qt_meta_atual_w
	from	pls_vendedor_meta_regra
	where	nr_seq_meta = nr_seq_vend_meta_seq_p
	and	nr_sequencia <> nr_seq_meta_regra_p;

	qt_metas_total_w := coalesce(qt_metas_novas_w,0) + coalesce(qt_meta_atual_w,0);

	if (qt_metas_total_w > qt_meta_maximo_w) then
		ds_erro_p := wheb_mensagem_pck.get_texto(280705);
		-- Mensagem: Quantidade de metas acima do limite permitidos para o mês. Favor verifique!
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_regra_qt_metas ( nr_seq_vend_meta_seq_p bigint, nr_seq_meta_regra_p bigint, qt_metas_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
