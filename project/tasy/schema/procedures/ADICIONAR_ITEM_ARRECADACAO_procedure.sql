-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adicionar_item_arrecadacao ( ds_linha_p text, nm_usuario_p text, ie_opcao_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_cgc_w			pessoa_juridica.ds_razao_social%type;
nm_pessoa_fisica_w		varchar(255);
ci_tipo_registro_w		bigint;
cd_conta_consumidor_w		varchar(100);
vl_pago_w			double precision;
dt_faturamento_w		timestamp;
dt_vencimento_w			timestamp;
dt_pagto_conta_w		timestamp;

c_interface CURSOR FOR
	SELECT	nm_atributo,
		qt_posicao_inicial,
		qt_tamanho,
		ds_mascara_data
	from	interface_atributo
	where	cd_interface	= 6;

vet_interface	c_interface%rowtype;


BEGIN

ds_erro_p	:= '';

if (ie_opcao_p	= 'I') then
	if (length(ds_linha_p) = 34) then
		begin
			open c_interface;
			loop
			fetch c_interface into
				vet_interface;
			EXIT WHEN NOT FOUND; /* apply on c_interface */
				begin

				if (vet_interface.nm_atributo = 'CI_TIPO_REGISTRO') then
					ci_tipo_registro_w	:= (substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho))::numeric;
				elsif (vet_interface.nm_atributo = 'NR_CONTA_CONSUMIDOR') then
					cd_conta_consumidor_w	:= substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho);
				elsif (vet_interface.nm_atributo = 'VL_PAGO') then
					vl_pago_w	:= dividir((substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho))::numeric ,100);
				elsif (vet_interface.nm_atributo = 'DT_FATURAMENTO') then
					dt_faturamento_w	:= to_date(substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho),vet_interface.ds_mascara_data);
				elsif (vet_interface.nm_atributo = 'DT_VENCIMENTO') then
					dt_vencimento_w		:= to_date(substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho),vet_interface.ds_mascara_data);
				elsif (vet_interface.nm_atributo = 'DT_PAGTO_CONTA') then
					dt_pagto_conta_w	:= to_date(substr(ds_linha_p,vet_interface.qt_posicao_inicial,vet_interface.qt_tamanho),vet_interface.ds_mascara_data);
				end if;
				end;
			end loop;
			close c_interface;

		exception
		when others then
			ds_erro_p	:= obter_desc_expressao(878021); --Erro de conversão nos valores durante a importação, verifique o arquivo.
		end;

		select 	max(ds_cgc),
			substr(max(nm_pessoa_fisica),1,255)
		into STRICT	ds_cgc_w,
			nm_pessoa_fisica_w
		from 	contribuinte_v
		where 	cd_ident_arrecadador = cd_conta_consumidor_w;

		insert into w_item_contribuicao(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_conta_consumidor,
						vl_pago,
						dt_faturamento,
						dt_vencimento,
						dt_pagamento,
						nm_contribuinte)
					values (nextval('w_item_contribuicao_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						cd_conta_consumidor_w,
						vl_pago_w,
						dt_faturamento_w,
						dt_vencimento_w,
						dt_pagto_conta_w,
						CASE WHEN coalesce(ds_cgc_w,'X')='X' THEN nm_pessoa_fisica_w  ELSE ds_cgc_w END );

		commit;
	else
		ds_erro_p	:= obter_desc_expressao(878023); --Erro durante a importação, a(s) linha(s) devem possuir 34 caracteres.
	end if;
elsif (ie_opcao_p	= 'E') then
	delete	FROM w_item_contribuicao;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adicionar_item_arrecadacao ( ds_linha_p text, nm_usuario_p text, ie_opcao_p text, ds_erro_p INOUT text) FROM PUBLIC;

