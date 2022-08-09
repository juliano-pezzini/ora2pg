-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dados_aval_checkup (nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_empresa_p bigint, nr_seq_tipo_p bigint, dt_registro_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_seq_tipo_w		bigint;
dt_referencia_w		timestamp;
dt_referencia_ww	timestamp;
dt_registro_w		timestamp;
ie_pos_checkup_w	varchar(10);

C01 CURSOR FOR
	SELECT	a.nr_sequencia	
	from	checkup_tipo_dado_estat a
	where	a.cd_empresa	= cd_empresa_p
	and	a.ie_situacao	= 'A'
	and	((nr_seq_tipo_p = 0) or (a.nr_sequencia = nr_seq_tipo_p))
	and	not exists (	SELECT	1
				from	checkup_dado_estat b
				where	b.nr_atendimento	= nr_atendimento_p
				and	b.nr_seq_tipo_dado	= a.nr_sequencia)
	order by a.nr_seq_apres;
	

BEGIN

OPEN C01;
LOOP
FETCH C01 into	
	nr_seq_tipo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	max(dt_referencia)
	into STRICT	dt_referencia_ww
	from	checkup_dado_estat
	where	nr_atendimento			= nr_atendimento_p
	and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_referencia)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_registro_p)
	and	ie_pos_checkup			= 'S';

	dt_registro_w		:= dt_registro_p;
	ie_pos_checkup_w	:= 'N';
	dt_referencia_w		:= obter_data_entrada(nr_atendimento_p);
	if (dt_referencia_ww IS NOT NULL AND dt_referencia_ww::text <> '') then
		dt_registro_w		:= dt_referencia_ww;
		dt_referencia_w		:= dt_referencia_ww;
		ie_pos_checkup_w	:= 'S';
	end if;

	select	nextval('checkup_dado_estat_seq')
	into STRICT	nr_sequencia_w
	;

	insert into checkup_dado_estat(
		nr_sequencia,
		nr_atendimento,
		dt_atualizacao,
		nm_usuario,
		nr_seq_tipo_dado,
		qt_dado,
		cd_pessoa_fisica,
		dt_registro,
		dt_referencia,
		ie_pos_checkup)
	values (	nr_sequencia_w,
		nr_atendimento_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_tipo_w,
		null,
		cd_pessoa_fisica_p,
		dt_registro_w,
		dt_referencia_w,
		ie_pos_checkup_w);
END LOOP;
CLOSE C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_aval_checkup (nr_atendimento_p bigint, cd_pessoa_fisica_p text, cd_empresa_p bigint, nr_seq_tipo_p bigint, dt_registro_p timestamp, nm_usuario_p text) FROM PUBLIC;
