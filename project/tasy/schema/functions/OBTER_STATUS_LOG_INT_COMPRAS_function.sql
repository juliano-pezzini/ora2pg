-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_log_int_compras ( nr_documento_p text, ie_documento_p text) RETURNS varchar AS $body$
DECLARE


/*ie_documento_p
C - Cotação de Compras
S - Solicitação de Compras
M - Cadastro de Material
F - Fornecedor*/
ie_status_envio_w		varchar(15);

c01 CURSOR FOR
SELECT	ie_status_envio
from	cot_compra_log_integracao
where	nr_cot_compra = nr_documento_p
order by dt_atualizacao,
	nr_sequencia;


c02 CURSOR FOR
SELECT	ie_status_envio
from	cot_compra_log_integracao
where	nr_solic_compra = nr_documento_p
order by dt_atualizacao,
	nr_sequencia;

c03 CURSOR FOR
SELECT	ie_status_envio
from	cot_compra_log_integracao
where	cd_material = nr_documento_p
order by dt_atualizacao,
	nr_sequencia;

c04 CURSOR FOR
SELECT	ie_status_envio
from	cot_compra_log_integracao
where	cd_cnpj = nr_documento_p
order by dt_atualizacao,
	nr_sequencia;


BEGIN

if (ie_documento_p = 'C') then
	open C01;
	loop
	fetch C01 into
		ie_status_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_status_envio_w := ie_status_envio_w;
		end;
	end loop;
	close C01;

elsif (ie_documento_p = 'S') then
	open C02;
	loop
	fetch C02 into
		ie_status_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		ie_status_envio_w := ie_status_envio_w;
		end;
	end loop;
	close C02;

elsif (ie_documento_p = 'M') then
	open C03;
	loop
	fetch C03 into
		ie_status_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ie_status_envio_w := ie_status_envio_w;
		end;
	end loop;
	close C03;

elsif (ie_documento_p = 'F') then
	open C04;
	loop
	fetch C04 into
		ie_status_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		ie_status_envio_w := ie_status_envio_w;
		end;
	end loop;
	close C04;
end if;

return	ie_status_envio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_log_int_compras ( nr_documento_p text, ie_documento_p text) FROM PUBLIC;
