-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_repasse_especial_mes (cd_estabelecimento_p bigint, nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_mesano_ref_p timestamp, dt_base_vencto_p timestamp, nr_seq_tipo_repasse_p text, ie_tipo_data_p bigint, ie_ignorar_periodo_p text, nr_seq_terceiro_p bigint, ie_tipo_convenio_p bigint, cd_condicao_pagamento_p text, ds_lista_regra_p text, ie_regra_repasse_p text) AS $body$
DECLARE


nr_seq_terceiro_w		bigint;
nr_repasse_terceiro_w	bigint;
nr_seq_tipo_w		bigint;
ie_not_regra_w		varchar(1);
ds_seq_regra_w		varchar(2000);
nr_seq_regra_w		regra_esp_repasse.nr_sequencia%type;
ie_excluir_rep_zerado_w	parametro_faturamento.ie_excluir_rep_zerado%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	terceiro a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	coalesce(a.ie_utilizacao, 'A') in ('A','R')
and	a.ie_situacao		= 'A'
and	a.nr_sequencia		= coalesce(nr_seq_terceiro_p,a.nr_sequencia);

c02 CURSOR FOR
SELECT	a.nr_sequencia
from	regra_esp_repasse a
where	a.ie_situacao	= 'A'
and	a.cd_estabelecimento	= cd_estabelecimento_p
and (coalesce(ds_seq_regra_w::text, '') = '' or (ie_not_regra_w = 'N' and (','||ds_seq_regra_w||',' like '%,'||to_char(a.nr_sequencia)||',%')) or (ie_not_regra_w = 'S' and not(','||ds_seq_regra_w||',' like '%,'||to_char(a.nr_sequencia)||',%')));


BEGIN

select	coalesce(max(ie_excluir_rep_zerado),'N')
into STRICT	ie_excluir_rep_zerado_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

nr_seq_tipo_w	:= (nr_seq_tipo_repasse_p)::numeric;

if (ds_lista_regra_p IS NOT NULL AND ds_lista_regra_p::text <> '') then
	if (position('not' in ds_lista_regra_p) = 1) then
		ds_seq_regra_w := substr(ds_lista_regra_p, 4);
		ie_not_regra_w := 'S';
	else
		ds_seq_regra_w := substr(ds_lista_regra_p,1,2000);
		ie_not_regra_w := 'N';
	end if;
else
	ds_seq_regra_w := null;
	ie_not_regra_w := null;
end if;

open c01;
loop
fetch c01 into
	nr_seq_terceiro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (coalesce(ie_regra_repasse_p,'N') = 'N') then
		begin
		select	coalesce(max(nr_repasse_terceiro),0)
		into STRICT	nr_repasse_terceiro_w
		from	repasse_terceiro x
		where	x.nr_seq_terceiro		= nr_seq_terceiro_w
		and	x.dt_periodo_inicial 	between dt_inicial_p and dt_final_p
		and	x.ie_status		= 'A';

		if	((nr_repasse_terceiro_w = 0 AND ie_ignorar_periodo_p = 'N') or (ie_ignorar_periodo_p = 'S') or (ie_ignorar_periodo_p = 'A')) then

			if (ie_ignorar_periodo_p = 'A') and (nr_repasse_terceiro_w <> 0) then
				update	repasse_terceiro set
					cd_estabelecimento	= cd_estabelecimento_p,
					dt_mesano_referencia	= coalesce(dt_mesano_ref_p, dt_final_p),
					ie_status			= 'A',
					dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					dt_periodo_inicial		= dt_inicial_p,
					dt_periodo_final		= dt_final_p,
					ie_tipo_data		= ie_tipo_data_p,
					dt_aprovacao_terceiro	 = NULL,
					nm_usuario_aprov		 = NULL,
					dt_base_vencto		= coalesce(dt_base_vencto_p,clock_timestamp()),
					nr_seq_tipo		= coalesce(nr_seq_tipo_w,nr_seq_tipo),
					ie_tipo_convenio		= ie_tipo_convenio_p,
					cd_condicao_pagamento   	= cd_condicao_pagamento_p
				where	nr_seq_terceiro		= nr_seq_terceiro_w
				and	dt_periodo_inicial 		between dt_inicial_p and dt_final_p
				and	ie_status			= 'A';
			else

				select	nextval('repasse_terceiro_seq')
				into STRICT	nr_repasse_terceiro_w
				;

				insert into repasse_terceiro(nr_repasse_terceiro,
					cd_estabelecimento,
					nr_seq_terceiro,
					dt_mesano_referencia,
					ie_status,
					dt_atualizacao,
					nm_usuario,
					cd_convenio,
					dt_periodo_inicial,
					dt_periodo_final,
					ie_tipo_data,
					dt_aprovacao_terceiro,
					nm_usuario_aprov,
					dt_base_vencto,
					nr_seq_tipo,
					ie_tipo_convenio,
					cd_condicao_pagamento)
				values (nr_repasse_terceiro_w,
					cd_estabelecimento_p,
					nr_seq_terceiro_w,
					coalesce(dt_mesano_ref_p, dt_final_p),
					'A',
					clock_timestamp(),
					nm_usuario_p,
					null,
					dt_inicial_p,
					dt_final_p,
					ie_tipo_data_p,
					null,
					null,
					coalesce(dt_base_vencto_p,clock_timestamp()),
					nr_seq_tipo_w,
					ie_tipo_convenio_p,
					cd_condicao_pagamento_p);
			end if;
		end if;

		if (coalesce(nr_repasse_terceiro_w,0) > 0) then
			open	c02;
			loop
			fetch	c02 into
				nr_seq_regra_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				CALL GERAR_REPASSE_ESPECIAL(nr_repasse_terceiro_w,nm_usuario_p,0,nr_seq_regra_w);
			end loop;
			close c02;
		end if;

		if (coalesce(ie_excluir_rep_zerado_w,'N') = 'S') then
			delete	from repasse_terceiro a
			where	not exists (SELECT	1
				from	repasse_terceiro_item x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro
				
union	all

				PERFORM	1
				from	procedimento_repasse x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro
				
union	all

				select	1
				from	material_repasse x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro)
			and	a.nr_repasse_terceiro	= nr_repasse_terceiro_w;
		end if;

		end;
	else
		begin
		open	c02;
		loop
		fetch	c02 into
			nr_seq_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			select	nextval('repasse_terceiro_seq')
			into STRICT	nr_repasse_terceiro_w
			;

			insert into repasse_terceiro(nr_repasse_terceiro,
				cd_estabelecimento,
				nr_seq_terceiro,
				dt_mesano_referencia,
				ie_status,
				dt_atualizacao,
				nm_usuario,
				cd_convenio,
				dt_periodo_inicial,
				dt_periodo_final,
				ie_tipo_data,
				dt_aprovacao_terceiro,
				nm_usuario_aprov,
				dt_base_vencto,
				nr_seq_tipo,
				ie_tipo_convenio,
				cd_condicao_pagamento)
			values (nr_repasse_terceiro_w,
				cd_estabelecimento_p,
				nr_seq_terceiro_w,
				coalesce(dt_mesano_ref_p, dt_final_p),
				'A',
				clock_timestamp(),
				nm_usuario_p,
				null,
				dt_inicial_p,
				dt_final_p,
				ie_tipo_data_p,
				null,
				null,
				coalesce(dt_base_vencto_p,clock_timestamp()),
				nr_seq_tipo_w,
				ie_tipo_convenio_p,
				cd_condicao_pagamento_p);

				if (coalesce(nr_repasse_terceiro_w,0) > 0) then
					CALL GERAR_REPASSE_ESPECIAL(nr_repasse_terceiro_w,nm_usuario_p,0,nr_seq_regra_w);
				end if;

			delete	from repasse_terceiro a
			where	not exists (SELECT	1
				from	repasse_terceiro_item x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro
				
union	all

				PERFORM	1
				from	procedimento_repasse x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro
				
union	all

				select	1
				from	material_repasse x
				where	x.nr_repasse_terceiro	= a.nr_repasse_terceiro)
			and	a.nr_repasse_terceiro	= nr_repasse_terceiro_w;
		end loop;
		close c02;
		end;
	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_repasse_especial_mes (cd_estabelecimento_p bigint, nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_mesano_ref_p timestamp, dt_base_vencto_p timestamp, nr_seq_tipo_repasse_p text, ie_tipo_data_p bigint, ie_ignorar_periodo_p text, nr_seq_terceiro_p bigint, ie_tipo_convenio_p bigint, cd_condicao_pagamento_p text, ds_lista_regra_p text, ie_regra_repasse_p text) FROM PUBLIC;
