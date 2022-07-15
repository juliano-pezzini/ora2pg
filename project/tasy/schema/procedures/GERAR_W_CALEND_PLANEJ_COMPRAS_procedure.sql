-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_calend_planej_compras ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, nr_seq_planej_compras_p bigint, nm_usuario_p text) AS $body$
DECLARE


i				smallint;
k				smallint;
qt_dia_w			smallint;

dt_referencia_w			timestamp;
dt_mesano_referencia_w		timestamp;
ie_feriado_w			varchar(1);
ie_planej_reprog_w		varchar(1);
ie_existe_planej_w		varchar(1);

ds_cor_w			varchar(15);


BEGIN

delete	FROM w_calend_planej_compras
where	nm_usuario = nm_usuario_p
and	cd_estabelecimento = cd_estabelecimento_p
and	nr_seq_planej_compras = nr_seq_planej_compras_p;

commit;

for i in 0..11 loop
	begin

	dt_mesano_referencia_w	:= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p,i,0),'month',0);
	qt_dia_w		:= PKG_DATE_UTILS.extract_field('DAY', PKG_DATE_UTILS.END_OF(dt_mesano_referencia_w, 'MONTH', 0) - 1);

	for k in 0..qt_dia_w loop
		begin
		dt_referencia_w := dt_mesano_referencia_w + k;

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_feriado_w
		from	feriado
		where	cd_estabelecimento = cd_estabelecimento_p
		and	dt_feriado = dt_referencia_w;

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_existe_planej_w
		from	planej_compras_calendario
		where	nr_seq_planej_compras = nr_seq_planej_compras_p
		and	cd_estabelecimento = cd_estabelecimento_p
		and	dt_planejamento = dt_referencia_w;

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_planej_reprog_w
		from	planej_compras_calendario
		where	nr_seq_planej_compras = nr_seq_planej_compras_p
		and	cd_estabelecimento = cd_estabelecimento_p
		and	dt_planejamento = dt_referencia_w
		and	coalesce(dt_cancelamento::text, '') = ''
		and	PKG_DATE_UTILS.start_of(dt_planejamento, 'dd', 0) <> PKG_DATE_UTILS.start_of(dt_planejamento_inicial, 'dd', 0);

		if (ie_planej_reprog_w = 'S') then
			ds_cor_w		:= '$00FF4646';
		elsif (ie_existe_planej_w = 'S') then

			select	CASE WHEN coalesce(max(dt_cancelamento)::text, '') = '' THEN 'clGreen'  ELSE 'clRed' END
			into STRICT	ds_cor_w
			from	planej_compras_calendario
			where	nr_seq_planej_compras = nr_seq_planej_compras_p
			and	cd_estabelecimento = cd_estabelecimento_p
			and	dt_planejamento = dt_referencia_w;

		elsif (ie_feriado_w = 'S') then
			ds_cor_w		:= 'clYellow';
		elsif (PKG_DATE_UTILS.IS_BUSINESS_DAY(dt_referencia_w, 0) = 0) then
			ds_cor_w		:= '$00E1E1E1';
		else
			ds_cor_w		:= 'clWhite';
		end if;

		insert into w_calend_planej_compras(
			cd_estabelecimento,
			nr_seq_planej_compras,
			dt_mesano_referencia,
			dt_referencia,
			nm_usuario,
			ds_cor)
		values (	cd_estabelecimento_p,
			nr_seq_planej_compras_p,
			dt_mesano_referencia_w,
			dt_referencia_w,
			nm_usuario_p,
			ds_cor_w);
		end;
	end loop;

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_calend_planej_compras ( cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, nr_seq_planej_compras_p bigint, nm_usuario_p text) FROM PUBLIC;

