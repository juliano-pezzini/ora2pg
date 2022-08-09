-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_lote_mensal_dmed ( nr_seq_dmed_mensal_p bigint, dt_referencia_p timestamp, retorno_p INOUT text, cd_estabelecimento_p bigint) AS $body$
DECLARE


dt_referencia_w		timestamp;
dt_referencia_maior_w	timestamp;
qt_registros_w		bigint;
nr_sequencia_maior_w	bigint;


BEGIN

-- Verificar se existem registros na tabela DMED_MENSAL
select count(*)
into STRICT	qt_registros_w
from	dmed_mensal;

if (qt_registros_w = 0) then --Não existem registros, portanto o lote mensal pode ser gravado
	retorno_p := 'V';
else
	select	fim_mes(dt_referencia_p)		-- Pegar o fim do mês de referência do lote que se deseha gerar
	into STRICT	dt_referencia_w
	;

	select 	count(*)				-- Verificar se existem registros com data posterior à data de refência
	into STRICT	qt_registros_w
	from	dmed_mensal
	where	fim_mes(dt_referencia) > dt_referencia_w
	and	(dt_geracao IS NOT NULL AND dt_geracao::text <> '')
	and	nr_sequencia <> nr_seq_dmed_mensal_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (qt_registros_w > 0) then			-- Existem lotes posteriores já gerados.
		retorno_p := 'F';
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266525,'MES=' || to_char(dt_referencia_p,'mm/yyyy'));

	else
		retorno_p := 'V';
	end if;

	select 	count(*)				-- Verificar se existem registros com data posterior à data de refência
	into STRICT	qt_registros_w
	from	dmed_mensal
	where	fim_mes(dt_referencia) = dt_referencia_w
	and	nr_sequencia <> nr_seq_dmed_mensal_p
	and	cd_estabelecimento = cd_estabelecimento_p;

	if (qt_registros_w > 0) then
		retorno_p := 'F';
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266526,'MES=' || to_char(dt_referencia_p,'mm/yyyy'));
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_lote_mensal_dmed ( nr_seq_dmed_mensal_p bigint, dt_referencia_p timestamp, retorno_p INOUT text, cd_estabelecimento_p bigint) FROM PUBLIC;
