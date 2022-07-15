-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_devolucao_material () AS $body$
DECLARE


cd_material_w		integer;
qt_estoque_w		double precision;
qt_movto_w		bigint;
nr_movimento_estoque_w	bigint;

c01 CURSOR FOR
SELECT	a.nr_movimento_estoque,
	a.cd_material_estoque,
	a.qt_estoque
from	movimento_estoque a
where	a.qt_estoque < 0
and	a.dt_movimento_estoque between to_date('01/11/2007','dd/mm/yyyy') and clock_timestamp();


BEGIN

select	count(*)
into STRICT	qt_movto_w
from	movimento_estoque a
where	a.qt_estoque < 0
and	a.dt_movimento_estoque between to_date('01/11/2007','dd/mm/yyyy') and clock_timestamp();

if (qt_movto_w > 0) then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(285639, 'QT_MOVTO_P=' || qt_movto_w);
	-- 285639 = 'Existem movimentos a serem verificados.' || '(' || qt_movto_w || ')' || chr(13) || chr(10) || 'Envie esta tela para o Suporte da Wheb');
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_devolucao_material () FROM PUBLIC;

