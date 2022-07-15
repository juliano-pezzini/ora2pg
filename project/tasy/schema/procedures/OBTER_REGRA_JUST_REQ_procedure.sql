-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_just_req ( nr_requisicao_p bigint, nr_sequencia_p INOUT bigint, ie_obriga_justif_p INOUT text) AS $body$
DECLARE


cd_operacao_estoque_w		smallint;
nr_sequencia_w			bigint;
ie_obriga_justif_w			varchar(1):= 'N';
ie_urgente_w			varchar(15);

c01 CURSOR FOR
	SELECT	ie_obriga_justif,
		nr_sequencia
	from	regra_justific_req
	where	coalesce(cd_operacao_estoque, cd_operacao_estoque_w)	= cd_operacao_estoque_w
	and (coalesce(ie_urgente, 'A') = ie_urgente_w or coalesce(ie_urgente, 'A') = 'A')
	order by	coalesce(cd_operacao_estoque,0);


BEGIN

select	cd_operacao_estoque,
	ie_urgente
into STRICT	cd_operacao_estoque_w,
	ie_urgente_w
from	requisicao_material
where	nr_requisicao	= nr_requisicao_p;

open c01;
loop
fetch c01 into
	ie_obriga_justif_w,
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_obriga_justif_p	:= ie_obriga_justif_w;
	nr_sequencia_p	:= nr_sequencia_w;
	end;
end loop;
close c01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_just_req ( nr_requisicao_p bigint, nr_sequencia_p INOUT bigint, ie_obriga_justif_p INOUT text) FROM PUBLIC;

