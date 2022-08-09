-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_dados_contr_segurado ( nr_seq_intercambio_p bigint, nm_usuario_p text, nr_seq_plano_p INOUT bigint, nr_seq_tabela_p INOUT bigint, nr_sequencia_p INOUT bigint, nr_seq_seg_contrato_p INOUT bigint) AS $body$
DECLARE


qt_intercambio_w		bigint;
qt_contrato_w			bigint;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_sequencia_w			bigint;
nr_seq_seg_contrato_w		bigint;


BEGIN
if (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then
	select	count(*)
	into STRICT	qt_intercambio_w
	from	pls_intercambio_plano
	where	nr_seq_intercambio = nr_seq_intercambio_p;

	if (qt_intercambio_w = 1) then
		begin
		select	nr_seq_plano,
			nr_seq_tabela
		into STRICT	nr_seq_plano_w,
			nr_seq_tabela_w
		from	pls_intercambio_plano
		where	nr_seq_intercambio = nr_seq_intercambio_p;
		end;
	end if;

	select	count(*)
	into STRICT	qt_contrato_w
	from	pls_contrato_pagador
	where	nr_seq_pagador_intercambio = nr_seq_intercambio_p;

	if (qt_contrato_w = 1) then
		begin
		select	nr_sequencia
		into STRICT	nr_sequencia_w
		from	pls_contrato_pagador
		where	nr_seq_pagador_intercambio = nr_seq_intercambio_p;
		end;
	end if;

	select	coalesce(max(nr_seq_seg_contrato),0) + 1
	into STRICT	nr_seq_seg_contrato_w
	from	pls_segurado
	where	nr_seq_intercambio = nr_seq_intercambio_p;
end if;

nr_seq_plano_p		:= nr_seq_plano_w;
nr_seq_tabela_p		:= nr_seq_tabela_w;
nr_sequencia_p		:= nr_sequencia_w;
nr_seq_seg_contrato_p	:= nr_seq_seg_contrato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_dados_contr_segurado ( nr_seq_intercambio_p bigint, nm_usuario_p text, nr_seq_plano_p INOUT bigint, nr_seq_tabela_p INOUT bigint, nr_sequencia_p INOUT bigint, nr_seq_seg_contrato_p INOUT bigint) FROM PUBLIC;
