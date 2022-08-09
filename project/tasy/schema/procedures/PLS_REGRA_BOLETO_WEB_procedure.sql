-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_regra_boleto_web ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nr_titulo_p bigint, qt_regra_p INOUT bigint, ie_permite_p INOUT text, ds_mensagem_p INOUT text, nr_seq_regra_p INOUT bigint, ie_data_alt_portal_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter regra de emissão de segunda via boleto
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ X ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
	Se  IE_PERMITE_P = 'N' e QT_REGRA_P > 0
		Bloqueia a tela, exibe a mensagem de bloqueio
	Senão
		Exibe os boletos
-------------------------------------------------------------------------------------------------------------------
Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_mensagem_w		 	varchar(2000)	:= '';
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w	 	varchar(10);
ie_permite_w		 	varchar(1)	:= 'S';
nr_seq_regra_w		 	bigint;
nr_seq_pagador_w	 	bigint;
qt_regra_w			smallint 	:= 0;
ie_data_alt_portal_w 		varchar(2) 	:= 'S';
ie_notificacao_atraso_w		varchar(1);
qt_notific_benef_w		bigint;
qt_regra_permissao_w		bigint;
ds_mensagem_ww			pls_visualizacao_bol_web.ds_mensagem%type;
nr_seq_forma_cobranca_w		pls_contrato_pagador_fin.nr_seq_forma_cobranca%type;
nr_seq_regra_vis_bol_w		pls_visualizacao_bol_web.nr_sequencia%type;
ie_permite_visualizar_w		pls_visualizacao_bol_web.ie_permite_visualizar%type;


BEGIN

ds_mensagem_ww := null;
ie_permite_w   := 'S';

select	count(1)
into STRICT	qt_regra_w
from	pls_regra_emis_seg_via_bol LIMIT 1;

begin
select	count(1)
into STRICT	qt_regra_permissao_w
from	pls_visualizacao_bol_web;
exception
when others then
	qt_regra_permissao_w := 0;
end;

select	max(a.nr_seq_pagador)
into STRICT	nr_seq_pagador_w
from	pls_segurado	a
where	a.nr_sequencia	= nr_seq_segurado_p;

select	max(nr_seq_forma_cobranca)
into STRICT	nr_seq_forma_cobranca_w
from	pls_contrato_pagador_fin
where	nr_seq_pagador = nr_seq_pagador_w
and	coalesce(dt_fim_vigencia::text, '') = '';

if (qt_regra_permissao_w = 0) then
	ie_permite_w := 'S';
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_vis_bol_w
	from	pls_visualizacao_bol_web
	where	((nr_seq_pagador = nr_seq_pagador_w) or (nr_seq_forma_cobranca = nr_seq_forma_cobranca_w));

	if (coalesce(nr_seq_regra_vis_bol_w::text, '') = '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_vis_bol_w
		from	pls_visualizacao_bol_web
		where	((nr_seq_pagador = nr_seq_pagador_w) or (coalesce(nr_seq_pagador::text, '') = ''))
		and	((nr_seq_forma_cobranca = nr_seq_forma_cobranca_w) or (coalesce(nr_seq_forma_cobranca::text, '') = ''));
	end if;

	if (nr_seq_regra_vis_bol_w IS NOT NULL AND nr_seq_regra_vis_bol_w::text <> '') then
		select	coalesce(max(ds_mensagem), obter_desc_expressao(10652230)),
			max(ie_permite_visualizar)
		into STRICT	ds_mensagem_ww,
			ie_permite_visualizar_w
		from	pls_visualizacao_bol_web
		where	nr_sequencia = nr_seq_regra_vis_bol_w;

		ie_permite_w := ie_permite_visualizar_w;
		end if;
end if;

if (qt_regra_w > 0) then
	select	max(a.cd_pessoa_fisica),
		max(a.cd_cgc)
	into STRICT	cd_pessoa_fisica_w,
		cd_cgc_w
	from	pls_contrato_pagador	a
	where	a.nr_sequencia	= nr_seq_pagador_w;

	nr_seq_regra_w	:= pls_obter_regra_seg_via_boleto(	cd_pessoa_fisica_w,
								cd_cgc_w,
								nr_seq_pagador_w,
								null,
								clock_timestamp(),
								'PO',
								cd_estabelecimento_p);

	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		begin
			select	coalesce(ds_mensagem, obter_desc_expressao(10652230)),
				coalesce(ie_data_alt_portal,'S'),
				ie_notificacao_atraso
			into STRICT	ds_mensagem_w,
				ie_data_alt_portal_w,
				ie_notificacao_atraso_w
			from	pls_regra_emis_seg_via_bol
			where	nr_sequencia	= nr_seq_regra_w;
		exception
		when others then
			ds_mensagem_w := null;
		end;

		if (ie_notificacao_atraso_w = 'S') then
			select	count(1)
			into STRICT	qt_notific_benef_w
			from	pls_notificacao_pagador
			where	nr_seq_pagador	= nr_seq_pagador_w;

			if (qt_notific_benef_w > 0) then
				ie_permite_w	:= 'N';
			end if;
		end if;
	end if;
end if;

if (ds_mensagem_ww IS NOT NULL AND ds_mensagem_ww::text <> '') then
	ds_mensagem_w := ds_mensagem_ww;
end if;

qt_regra_p	:= qt_regra_w;
ie_permite_p	:= ie_permite_w;
ds_mensagem_p	:= ds_mensagem_w;

nr_seq_regra_p  := nr_seq_regra_w;
ie_data_alt_portal_p := ie_data_alt_portal_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_boleto_web ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nr_titulo_p bigint, qt_regra_p INOUT bigint, ie_permite_p INOUT text, ds_mensagem_p INOUT text, nr_seq_regra_p INOUT bigint, ie_data_alt_portal_p INOUT text) FROM PUBLIC;
