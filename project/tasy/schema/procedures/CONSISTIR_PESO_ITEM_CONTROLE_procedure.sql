-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_peso_item_controle ( nr_seq_item_p bigint, qt_item_p bigint, qt_peso_item_p bigint, ds_consistencia_p INOUT text ) AS $body$
DECLARE


qt_peso_minimo_w	double precision;
qt_peso_maximo_w	double precision;


BEGIN
ds_consistencia_p	:= null;

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') then
	select	coalesce(qt_peso_minimo,0),
		coalesce(qt_peso_maximo,0)
	into STRICT	qt_peso_minimo_w,
		qt_peso_maximo_w
	from	pepo_item_controle
	where	nr_sequencia = nr_seq_item_p;
end if;

if (qt_peso_maximo_w > 0) and (dividir(qt_peso_item_p,qt_item_p) > qt_peso_maximo_w) then
	ds_consistencia_p := Wheb_mensagem_pck.get_texto(306549); -- 'O peso do item esta acima do peso máximo aceitável!';
elsif (qt_peso_minimo_w > 0) and (dividir(qt_peso_item_p,qt_item_p) < qt_peso_minimo_w) then
	ds_consistencia_p := Wheb_mensagem_pck.get_texto(306550); -- 'O peso do item esta abaixo do peso mínimo aceitável!';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_peso_item_controle ( nr_seq_item_p bigint, qt_item_p bigint, qt_peso_item_p bigint, ds_consistencia_p INOUT text ) FROM PUBLIC;

