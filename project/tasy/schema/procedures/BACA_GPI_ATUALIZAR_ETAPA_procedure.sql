-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (	nr_seq_cronograma	bigint,
			nr_seq_estrutura	bigint,
			nr_seq_superior		bigint,
			nr_seq_apres		bigint,
			ds_titulo		varchar(100),
			ie_ativ_estrut		varchar(1),
			nr_seq_nova_etapa	bigint);


CREATE OR REPLACE PROCEDURE baca_gpi_atualizar_etapa () AS $body$
DECLARE


type vetor is table of campos index by integer;

estrutura_w			vetor;
i				integer	:= 0;
k				integer	:= 0;
ds_titulo_w			varchar(100);
ie_ativ_estrut_w		varchar(1);
nr_seq_cronograma_w		bigint;
nr_seq_apres_w			bigint	:= 1;
nr_seq_apres_etapa_w		bigint	:= 1;
nr_seq_apres_etapa_ww		bigint	:= 1;
nr_seq_estrutura_w		bigint;
nr_seq_etapa_w			bigint;
nr_seq_etapa_ww			bigint;
nr_seq_superior_w		bigint;
qt_registro_w			bigint;

C02 CURSOR FOR
SELECT	a.nr_sequencia
from	gpi_cron_etapa a
where	a.nr_seq_estrutura	= nr_seq_estrutura_w
order by a.nr_seq_apres;

c03 CURSOR FOR
SELECT	a.nr_seq_cronograma,
	a.nr_sequencia,
	a.nr_seq_superior,
	a.ie_ativ_estrut,
	a.ds_titulo
from	gpi_cron_estrut a
where	qt_registro_w > 0
order by 1,a.nr_seq_apres;


BEGIN

select count(*)
into STRICT	qt_registro_w
from	gpi_cron_etapa
where	coalesce(nr_seq_cronograma::text, '') = '';

if (qt_registro_w > 0) then

	update	gpi_cron_Etapa
	set	nr_Seq_superior  = NULL
	where	nm_usuario = 'Tasy';

	delete from gpi_cron_etapa
	where	nm_usuario_nrec = 'Tasy';
	commit;
end if;
i	:= 0;

open C03;
loop
fetch C03 into
	nr_seq_cronograma_w,
	nr_seq_estrutura_w,
	nr_seq_superior_w,
	ie_ativ_estrut_w,
	ds_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	estrutura_w[i].nr_seq_cronograma	:= nr_seq_cronograma_w;
	estrutura_w[i].nr_seq_estrutura		:= nr_seq_estrutura_w;
	estrutura_w[i].nr_seq_superior		:= nr_seq_superior_w;
	estrutura_w[i].ds_titulo		:= ds_titulo_w;
	estrutura_w[i].ie_ativ_estrut		:= ie_ativ_estrut_w;

	i	:= i + 1;
	end;
end loop;
close C03;

for i in 0..estrutura_w.Count - 1 loop
	begin
	nr_seq_estrutura_w	:= estrutura_w[i].nr_seq_estrutura;

	select	nextval('gpi_cron_etapa_seq')
	into STRICT	nr_seq_etapa_w
	;

	if (nr_seq_cronograma_w = estrutura_w[i].nr_seq_cronograma) then
		nr_seq_apres_w		:= 1;
		nr_seq_apres_etapa_w	:= 1;
		nr_seq_apres_etapa_ww	:= 1;
	end if;

	if (coalesce(estrutura_w[i].nr_seq_superior ,0) = 0) then

		insert into gpi_cron_etapa(
			nr_sequencia,
			nr_seq_cronograma,
			nr_seq_superior,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_apres,
			nm_etapa,
			ds_objetivo,
			dt_inicio_prev,
			dt_fim_prev,
			dt_inicio_real,
			dt_fim_real,
			qt_hora_prev,
			qt_hora_real,
			pr_etapa)
		values (	nr_seq_etapa_w,
			estrutura_w[i].nr_seq_cronograma,
			null,
			clock_timestamp(),
			'Tasy',
			clock_timestamp(),
			'Tasy',
			nr_seq_apres_etapa_w,
			estrutura_w[i].ds_titulo,
			estrutura_w[i].ds_titulo,
			null,
			null,
			null,
			null,
			0,
			0,
			0);
		nr_seq_apres_etapa_w			:= nr_seq_apres_etapa_w + 1;
		estrutura_w[i].nr_seq_nova_etapa	:= nr_seq_etapa_w;
	else
		begin
		insert into gpi_cron_etapa(
			nr_sequencia,
			nr_seq_cronograma,
			nr_seq_superior,
			nr_seq_estrutura,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_apres,
			nm_etapa,
			ds_objetivo,
			dt_inicio_prev,
			dt_fim_prev,
			dt_inicio_real,
			dt_fim_real,
			qt_hora_prev,
			qt_hora_real,
			pr_etapa)
		values (	nr_seq_etapa_w,
			estrutura_w[i].nr_seq_cronograma,
			null,
			null,
			clock_timestamp(),
			'Tasy',
			clock_timestamp(),
			'Tasy',
			nr_seq_apres_w,
			estrutura_w[i].ds_titulo,
			estrutura_w[i].ds_titulo,
			null,
			null,
			null,
			null,
			0,
			0,
			0);
		nr_seq_apres_w				:= nr_seq_apres_w +1;
		estrutura_w[i].nr_seq_nova_etapa	:= nr_seq_etapa_w;
		end;
	end if;

	if (estrutura_w[i].ie_ativ_estrut = 'A') then
		begin
		nr_seq_apres_etapa_ww	:= 1;
		open C02;
		loop
		fetch C02 into
			nr_seq_etapa_ww;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			update	gpi_cron_etapa
			set	nr_seq_cronograma	= estrutura_w[i].nr_seq_cronograma,
				nr_seq_apres		= nr_seq_apres_etapa_ww,
				nr_seq_superior		= estrutura_w[i].nr_seq_nova_etapa,
				dt_atualizacao		= clock_timestamp(),
				nm_usuario		= 'Tasy'
			where	nr_sequencia		= nr_seq_etapa_ww;

			nr_seq_apres_etapa_ww	:= nr_seq_apres_etapa_ww +1;
			end;
		end loop;
		close C02;
		nr_seq_apres_etapa_ww	:= 1;
		end;
	end if;
	nr_seq_cronograma_w	:= estrutura_w[i].nr_seq_cronograma;
	end;
end loop;

for i in 0..estrutura_w.Count - 1 loop
	begin
	if (coalesce(estrutura_w[i].nr_seq_superior ,0) <> 0) then
		begin
		for k in 0..estrutura_w.Count -1 loop
			begin

			if (estrutura_w[k].nr_seq_estrutura = estrutura_w[i].nr_seq_superior) then
				update	gpi_cron_etapa
				set	nr_seq_superior = estrutura_w[k].nr_seq_nova_etapa
				where	nr_sequencia	= estrutura_w[i].nr_seq_nova_etapa;
			end if;

			end;
		end loop;
		end;
	end if;
	end;
end loop;
commit;
CALL exec_sql_dinamico('Matheus','alter table gpi_cron_etapa modify nr_seq_cronograma not null');

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_gpi_atualizar_etapa () FROM PUBLIC;

