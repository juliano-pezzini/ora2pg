-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_gerar_seq_envio_prot ( nr_seq_protocolo_p bigint, cd_convenio_p bigint, cd_interface_envio_p bigint, ie_tipo_protocolo_p text, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_envio_conv_p INOUT bigint, nr_seq_env_calc_p INOUT bigint, nm_arquivo_p INOUT text) AS $body$
DECLARE


ie_tipo_regra_w			varchar(01);
qt_regra_w			integer;
nr_seq_envio_conv_w		bigint;
nr_multiplo_envio_w		bigint;
cd_convenio_princ_w		integer;
ie_regra_arquivo_w			varchar(10);
cd_interno_w			varchar(15);
indice				smallint;
nm_arquivo_w			varchar(100);
ds_diretorio_padrao_w		varchar(100);
nr_seq_arq_w			varchar(30);
cd_estabelecimento_w		bigint;
nr_seq_envio_prot_w		bigint;
nr_seq_envio_prot_conv_w		bigint;
nr_seq_inicial_w			bigint;
ds_arquivo_envio_w		varchar(255);
cd_interface_envio_w		varchar(10);
ds_sql_interface_w		varchar(2000);
cd_interface_envio_ww		integer;

c01 CURSOR FOR
	SELECT	coalesce(ie_tipo_regra, 'S'),
		coalesce(cd_convenio_princ,0),
		ie_regra_arquivo,
		null,
		coalesce(nr_seq_envio_prot,0)
	from	conv_regra_envio_protocolo
	where	cd_convenio				= cd_convenio_p
	and	coalesce(ie_tipo_protocolo, ie_tipo_protocolo_p)	= ie_tipo_protocolo_p
	and	((nr_seq_envio_prot_w = 0) or (coalesce(ds_arquivo_envio_w,'0') = '0' ))
	order by ie_tipo_protocolo;


BEGIN

select	coalesce(nr_multiplo_envio, 0)
into STRICT	nr_multiplo_envio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

select	count(*)
into STRICT	qt_regra_w
from	conv_regra_envio_protocolo
where	cd_convenio		= cd_convenio_p;

select	coalesce(max(cd_estabelecimento),wheb_usuario_pck.get_cd_estabelecimento),
	coalesce(max(nr_seq_envio_convenio),0),
	coalesce(max(ds_arquivo_envio),'0')
into STRICT	cd_estabelecimento_w,
	nr_seq_envio_prot_w,
	ds_arquivo_envio_w
from	protocolo_convenio
where	nr_seq_protocolo	= nr_seq_protocolo_p;


select	coalesce(max(nr_seq_envio_prot),0)
into STRICT	nr_seq_envio_prot_conv_w
from	convenio_estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_w
and	cd_convenio	= cd_convenio_p;


if (qt_regra_w	= 0) then
	begin

	if (nr_seq_envio_prot_w = 0) then
		select	coalesce(max(nr_seq_envio_convenio),nr_seq_envio_prot_conv_w) + 1
		into STRICT	nr_seq_envio_conv_w
		from	protocolo_convenio
		where	cd_convenio	= cd_convenio_p;
	end if;

	end;
else
	begin

	open	c01;
	loop
	fetch	c01 into	ie_tipo_regra_w,
				cd_convenio_princ_w,
				ie_regra_arquivo_w,
				ds_diretorio_padrao_w,
				nr_seq_inicial_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (nr_seq_envio_prot_w = 0) then

			if (ie_tipo_regra_w = 'S') then
				select	coalesce(max(nr_seq_envio_convenio),nr_seq_envio_prot_conv_w) + 1
				into STRICT	nr_seq_envio_conv_w
				from	protocolo_convenio
				where	cd_convenio	= cd_convenio_p;
			elsif (ie_tipo_regra_w = 'M') then
				select	coalesce(max(nr_seq_envio_convenio),nr_seq_envio_prot_conv_w) + 1
				into STRICT	nr_seq_envio_conv_w
				from	protocolo_convenio
				where	cd_convenio			= cd_convenio_p
				and	trunc(dt_mesano_referencia, 'month') = trunc(dt_mesano_referencia_p, 'month');
			elsif (ie_tipo_regra_w = 'I') then
				select	coalesce(max(nr_seq_envio_convenio), nr_seq_inicial_w) + 1
				into STRICT	nr_seq_envio_conv_w
				from	protocolo_convenio
				where	cd_convenio			= cd_convenio_p
				and	trunc(dt_mesano_referencia, 'month') = trunc(dt_mesano_referencia_p, 'month')
				and	coalesce(ie_tipo_protocolo, ie_tipo_protocolo_p)	= ie_tipo_protocolo_p;
			elsif (ie_tipo_regra_w = 'P') then

				if (cd_convenio_princ_w = 0) then
					--'O convênio principal deve ser informado na regra de envio do protocolo!';
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(253495);
				end if;

				select	coalesce(max(nr_seq_envio_convenio),nr_seq_envio_prot_conv_w) + 1
				into STRICT	nr_seq_envio_conv_w
				from	protocolo_convenio
				where	cd_convenio	in (
					SELECT	cd_convenio_princ_w
					
					
union all

					SELECT	cd_convenio
					from	conv_regra_envio_protocolo
					where	cd_convenio_princ = cd_convenio_princ_w);
			elsif (ie_tipo_regra_w = 'Z') then

				if (cd_convenio_princ_w = 0) then
					CALL Wheb_mensagem_pck.exibir_mensagem_abort(253496);
				end if;

				select	coalesce(max(nr_seq_envio_convenio),nr_seq_envio_prot_conv_w) + 1
				into STRICT	nr_seq_envio_conv_w
				from	protocolo_convenio
				where	cd_convenio	in (
					SELECT	cd_convenio_princ_w
					
					
union all

					SELECT	cd_convenio
					from	conv_regra_envio_protocolo
					where	cd_convenio_princ = cd_convenio_princ_w)
				and	trunc(dt_mesano_referencia, 'month') = trunc(dt_mesano_referencia_p, 'month');

			end if;
		end if;
		end;
	end loop;
	close	c01;

	indice		:= 1;
	nm_arquivo_w	:= '';

	if (ie_regra_arquivo_w IS NOT NULL AND ie_regra_arquivo_w::text <> '') then

		select	obter_valor_conv_estab(cd_convenio, cd_estabelecimento_w, 'CD_INTERNO')
		into STRICT	cd_interno_w
		from	convenio
		where	cd_convenio	= cd_convenio_p;

		if (nr_seq_envio_prot_w <> 0) then
			nr_seq_arq_w:= nr_seq_envio_prot_w;
		else
			nr_seq_arq_w	:= nr_seq_envio_conv_w;
		end if;

		if (length(nr_seq_envio_conv_w) < 4) then
			nr_seq_arq_w	:= substr(to_char(nr_seq_envio_conv_w, '0000'),2,4);
		end if;

		if (cd_interface_envio_p = 0) then
			select	max(a.cd_interface_envio)
			into STRICT	cd_interface_envio_ww
			from	param_interface a
			where	a.cd_convenio = cd_convenio_p
			and	coalesce(a.ie_tipo_protocolo, ie_tipo_protocolo_p) = ie_tipo_protocolo_p
			and	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
			and	(a.ds_sql_interface IS NOT NULL AND a.ds_sql_interface::text <> '');
		end if;

		select	coalesce(max(CASE WHEN CASE WHEN cd_interface_envio_p=0 THEN cd_interface_envio_ww  ELSE cd_interface_envio_p END =1010 THEN '.035' WHEN CASE WHEN cd_interface_envio_p=0 THEN cd_interface_envio_ww  ELSE cd_interface_envio_p END =1009 THEN '.055' WHEN CASE WHEN cd_interface_envio_p=0 THEN cd_interface_envio_ww  ELSE cd_interface_envio_p END =1006 THEN CASE WHEN ie_tipo_protocolo_p=1 THEN '.075'  ELSE '.085' END  WHEN CASE WHEN cd_interface_envio_p=0 THEN cd_interface_envio_ww  ELSE cd_interface_envio_p END =2676 THEN CASE WHEN ie_tipo_protocolo_p=1 THEN '.075'  ELSE '.085' END  END ),'.000')
		into STRICT	cd_interface_envio_w
		;

		for indice in 1..length(ie_regra_arquivo_w) loop


			if (substr(ie_regra_arquivo_w,indice,1) = 'P') then
				nm_arquivo_w	:= nm_arquivo_w || cd_interno_w;
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'R') then
				nm_arquivo_w	:= nm_arquivo_w || lpad(coalesce(cd_interno_w,0),3,0);
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'L') then
				nm_arquivo_w	:= nm_arquivo_w || 'H';
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'M') then
				nm_arquivo_w	:= nm_arquivo_w || to_char(dt_mesano_referencia_p, 'mmyy');
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'N') then
				nm_arquivo_w	:= nm_arquivo_w || to_char(dt_mesano_referencia_p, 'yyyymm');
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'T') then
				nm_arquivo_w	:= nm_arquivo_w || nr_seq_protocolo_p;
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'S') then
				nm_arquivo_w	:= nm_arquivo_w || nr_seq_arq_w;
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'H') then
				nm_arquivo_w	:= nm_arquivo_w || 'SMH';
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'I') then
				nm_arquivo_w	:= nm_arquivo_w || cd_interno_w;
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'A') then
				nm_arquivo_w	:= nm_arquivo_w || cd_interface_envio_w;
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'V') then
				nm_arquivo_w	:= nm_arquivo_w || 'PL';
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'U') then
				nm_arquivo_w	:= nm_arquivo_w || cd_interno_w||'_';
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'D') then
				nm_arquivo_w	:= nm_arquivo_w || to_char(clock_timestamp(),'ddmmyy')||'_';
			elsif (substr(ie_regra_arquivo_w,indice,1) = 'F') then
				nm_arquivo_w	:= nm_arquivo_w || 'TextoLivre';
			else
				nm_arquivo_w	:= nm_arquivo_w || substr(ie_regra_arquivo_w,indice,1);
			end if;
		end loop;

		if (ie_regra_arquivo_w = 'T') then
			nm_arquivo_w := ds_diretorio_padrao_w || nm_arquivo_w || '.txt';
		else
			nm_arquivo_w := ds_diretorio_padrao_w || nm_arquivo_w;
		end if;
	end if;
	end;
end if;

nr_seq_envio_conv_p	:= coalesce(nr_seq_envio_conv_w, nr_seq_envio_prot_w);
nr_seq_env_calc_p	:= mod(nr_seq_envio_conv_w, nr_multiplo_envio_w);
nm_arquivo_p		:= nm_arquivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_gerar_seq_envio_prot ( nr_seq_protocolo_p bigint, cd_convenio_p bigint, cd_interface_envio_p bigint, ie_tipo_protocolo_p text, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_envio_conv_p INOUT bigint, nr_seq_env_calc_p INOUT bigint, nm_arquivo_p INOUT text) FROM PUBLIC;

