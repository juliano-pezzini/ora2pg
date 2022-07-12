-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_regulacao ( nr_sequencia_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


	nr_seq_regulacao_w regulacao_atend.nr_sequencia%type := 0;


BEGIN

	if (ie_tipo_p = 'EVOL') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_regulacao_w
		from	regulacao_atend
		where	cd_evolucao_ori = nr_sequencia_p;

	elsif (ie_tipo_p = 'SOLIC_EXAME') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_regulacao_w
		from	regulacao_atend
		where	nr_seq_pedido = nr_sequencia_p;


	end if;

	return nr_seq_regulacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_regulacao ( nr_sequencia_p bigint, ie_tipo_p text) FROM PUBLIC;

