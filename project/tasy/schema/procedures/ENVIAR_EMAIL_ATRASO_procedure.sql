-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_atraso (cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_cnpj_w			varchar(14);
nr_nota_fiscal_w		varchar(255);
nr_titulo_w			bigint;
vl_titulo_w			double precision;
qt_dia_util_w			bigint;
dt_emissao_w			timestamp;
dt_pagamento_previsto_w		timestamp;
dt_retorno_w			timestamp;
dia_w				timestamp;
ds_email_destino_w		varchar(255);
ds_email_origem_w		varchar(255);
ds_assunto_w			varchar(1000);
ds_mensagem_w			varchar(2000);

C01 CURSOR FOR
	SELECT	cd_cnpj,
		substr(wheb_obter_email_estab_pj(cd_cnpj),1,254)
	from	com_cliente
	where	ie_situacao = 'A'
	and	ie_classificacao = 'C';

C02 CURSOR FOR
	SELECT	b.nr_nota_fiscal,
		a.dt_emissao,
		a.nr_titulo,
		a.vl_titulo,
		a.dt_pagamento_previsto
	FROM titulo_receber a
LEFT OUTER JOIN nota_fiscal b ON (a.nr_seq_nf_saida = b.nr_sequencia)
WHERE a.cd_cgc = cd_cnpj_w and (SELECT max(c.dt_recebimento) from titulo_receber_liq c where c.nr_titulo = a.nr_titulo) is null;


BEGIN
open C01;
loop
fetch C01 into
	cd_cnpj_w,
	ds_email_destino_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		nr_nota_fiscal_w,
		dt_emissao_w,
		nr_titulo_w,
		vl_titulo_w,
		dt_pagamento_previsto_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		dia_w := dt_pagamento_previsto_w;
		qt_dia_util_w := 0;
		while(qt_dia_util_w < 2) loop
			begin
			dia_w := dia_w + 1;
			if (obter_se_dia_util(dia_w, cd_estabelecimento_p) = 'S') then
				qt_dia_util_w := qt_dia_util_w + 1;
			end if;
			dt_retorno_w := dia_w;
			end;
		end loop;
		if (to_date(to_char(dt_retorno_w,'DD/MM/YYYY'),'DD/MM/YYYY') = to_date(to_char(clock_timestamp(),'DD/MM/YYYY'),'DD/MM/YYYY')) then
			begin
			ds_assunto_w  := wheb_mensagem_pck.get_texto(307422); -- Nota fiscal
			ds_mensagem_w := wheb_mensagem_pck.get_texto(307423,'NR_NOTA_FISCAL_W=' || nr_nota_fiscal_w || ';' ||
																'DT_EMISSAO_W=' || dt_emissao_w || ';' ||
																'DT_PAGAMENTO_PREVISTO_W=' || dt_pagamento_previsto_w || ';' ||
																'VL_TITULO_W=' || vl_titulo_w);
						/*
							Prezado Cliente

							Identificamos que a nota fiscal #@NR_NOTA_FISCAL_W#@, emitida pela Philips Clinical Informatics em #@DT_EMISSAO_W#@
							com vencimento em #@DT_PAGAMENTO_PREVISTO_W#@ no valor de R$ #@VL_TITULO_W#@ continua em aberto em
							nossos controles.

							Favor verificar se a nota fiscal foi recebida e devidamente registrada nos
							vossos controles internos para programação de pagamento.

							Se eventualmente a nota fiscal não foi recebida, solicitamos que entrem em
							contato conosco pelo e-mail financeiropci@philips.com.com.br, ou pelo telefone (47)
							3144-4000, para enviarmos a nota fiscal.

							Se a mesma estiver em em aberto nos vossos controles, favor nos posicionar
							com uma data de programação de pagamento para nosso controle do fluxo de
							caixa.
							Se a mesma já foi paga, favor desconsiderar este e-mail.

							Atenciosamente
							Departamento Financeiro
							Philips Clinical Informatics
						*/
			ds_email_origem_w := 'financeiropci@philips.com.com.br';
			CALL enviar_email(ds_assunto_w, ds_mensagem_w, ds_email_origem_w, ds_email_destino_w, 'Tasy', 'A');
			end;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_atraso (cd_estabelecimento_p bigint) FROM PUBLIC;
