-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE repetir_escala ( nr_seq_escala_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, dt_ref_inic_p timestamp, dt_ref_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		integer;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_inic_orig_w		timestamp;
dt_fim_orig_w			timestamp;
dt_origem_w			timestamp;
dt_escala_w			timestamp;
hr_inicial_w			varchar(08);
dt_inicio_w			timestamp;
dt_fim_w			timestamp;

nr_sequencia_w		bigint    := 0;
cd_pessoa_fisica_w		varchar(010);
ds_observacao_w		varchar(255);
ie_feriado_w			varchar(001);
qt_dia_w			bigint;
qt_duracao_w			double precision;
nr_seq_escala_diaria_w		bigint;
cd_pessoa_fisica_adic_w		varchar(10);
nr_seq_classif_escala_w		bigint;

C01 CURSOR FOR
SELECT	nr_sequencia,
	to_char(dt_inicio,'hh24:mi:ss'),
	cd_pessoa_fisica,
	ds_observacao,
	dt_fim - dt_inicio
From 	Escala_Diaria
where 	nr_seq_escala		= nr_seq_escala_p
and	dt_inicio between dt_origem_w and PKG_DATE_UTILS.END_OF(dt_origem_w, 'DAY', 0)
order by 1,2;

c02 CURSOR FOR
SELECT	cd_pessoa_fisica,
	nr_seq_classif_escala
from	escala_diaria_adic
where	nr_seq_escala_diaria	= nr_seq_escala_diaria_w;


BEGIN

if (dt_inicial_p > dt_final_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265601,'');
	--Mesagem: A data inicial não pode ser maior que a final!
end if;
if (dt_ref_inic_p > dt_ref_final_p) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265604,'');
	--A data de referência inicial não pode ser maior que a final!
end if;

if (dt_inicial_p < PKG_DATE_UTILS.start_of(clock_timestamp(),'dd',0)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265605,'');
	--A data de inicial não pode ser menor que hoje!
end if;

if (PKG_DATE_UTILS.start_of(dt_ref_final_p,'dd',0) >= PKG_DATE_UTILS.start_of(dt_inicial_p,'dd',0)) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265606,'');
	--A data de referência final deve ser menor que a inicial para repetição!
end if;

qt_dia_w	:= trunc((PKG_DATE_UTILS.start_of(dt_ref_final_p,'dd',0) - PKG_DATE_UTILS.start_of(dt_ref_inic_p,'dd',0)),0);

if (qt_dia_w > 31) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265607,'');
	--O Período de referência para cópia não pode ser maior que 31 dias!
end if;

select	c.cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	escala_classif c,
	escala_grupo b,
	escala a
where	a.nr_sequencia	= nr_seq_escala_p
and	a.nr_seq_grupo	= b.nr_sequencia
and	b.nr_seq_classif	= c.nr_sequencia;

dt_inic_orig_w		:= PKG_DATE_UTILS.start_of(dt_ref_inic_p,'dd',0);
dt_fim_orig_w			:= PKG_DATE_UTILS.start_of(dt_ref_final_p,'dd',0);

dt_inicial_w			:= PKG_DATE_UTILS.start_of(dt_inicial_p,'dd',0);
dt_final_w			:= PKG_DATE_UTILS.start_of(dt_final_p,'dd',0);
dt_escala_w			:= dt_inicial_w;

delete	from escala_diaria
where	nr_seq_escala		= nr_seq_escala_p
and	dt_inicio		>= dt_inicial_w
and	dt_fim			<= dt_final_w;
commit;

While(dt_escala_w <= dt_final_w) LOOP
	dt_origem_w		:= dt_inic_orig_w;
	while(dt_origem_w <= dt_fim_orig_w) and (dt_escala_w <= dt_final_w) LOOP
		OPEN C01;
		LOOP
		FETCH C01 into
			nr_seq_escala_diaria_w,
			hr_inicial_w,
			cd_pessoa_fisica_w,
			ds_observacao_w,
			qt_duracao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			dt_inicio_w		:= PKG_DATE_UTILS.get_Time(dt_escala_w, hr_inicial_w);
			dt_fim_w		:= dt_inicio_w + qt_duracao_w;
			select CASE WHEN obter_se_feriado(cd_estabelecimento_w, PKG_DATE_UTILS.start_of(dt_escala_w,'dd',0))=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_feriado_w
			;
			select	nextval('escala_diaria_seq')
			into STRICT	nr_sequencia_w
			;
			insert into escala_diaria(
				nr_sequencia,
				nr_seq_escala,
				dt_atualizacao,
				nm_usuario,
				dt_inicio,
				dt_fim,
				ie_feriado,
				cd_pessoa_fisica,
				cd_pessoa_origem,
				ds_observacao)
			values (
				nr_sequencia_w,
				nr_seq_escala_p,
				clock_timestamp(),
				nm_usuario_p,
				dt_inicio_w,
				dt_fim_w,
				coalesce(ie_feriado_w,'N'),
				cd_pessoa_fisica_w,
				cd_pessoa_fisica_w,
				ds_observacao_w);

			/* Francisco - OS 97749 - 21/06/2008 */

			open c02;
			loop
			fetch c02 into
				cd_pessoa_fisica_adic_w,
				nr_seq_classif_escala_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				insert	into	escala_diaria_adic(nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					dt_atualizacao_nrec,
					nr_seq_escala_diaria,
					cd_pessoa_fisica,
					nr_seq_classif_escala)
				values (nextval('escala_diaria_adic_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nr_sequencia_w,
					cd_pessoa_fisica_adic_w,
					nr_seq_classif_escala_w);
			end loop;
			close c02;
		END LOOP;
		CLOSE C01;
		dt_origem_w	:= dt_origem_w + 1;
		dt_escala_w	:= dt_escala_w + 1;
	END LOOP;
END LOOP;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE repetir_escala ( nr_seq_escala_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, dt_ref_inic_p timestamp, dt_ref_final_p timestamp, nm_usuario_p text) FROM PUBLIC;
