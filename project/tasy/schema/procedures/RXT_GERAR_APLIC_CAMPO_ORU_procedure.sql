-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rxt_gerar_aplic_campo_oru (cd_pessoa_fisica_p text, cd_protocolo_externo_p text, cd_campo_externo_p text, dt_agenda_p timestamp, qt_dose_p text ) AS $body$
DECLARE


nr_seq_rxt_protocolo_w bigint;	
nr_seq_rxt_tratamento_w bigint;	
nr_seq_rxt_agenda_w bigint;
rxt_campo_nr_sequencia_w bigint;
cd_medico_rxt_tumor_w varchar(10);
nr_seq_fase_w bigint;


BEGIN

	select max(b.nr_sequencia),
	max(b.nr_seq_protocolo)
	into STRICT nr_seq_rxt_tratamento_w,
	nr_seq_rxt_protocolo_w
	from rxt_tumor a,
	rxt_tratamento b,
	rxt_protocolo c,
	rxt_campo_protocolo d
	where b.nr_seq_tumor = a.nr_sequencia
	and a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and c.nr_sequencia = b.nr_seq_protocolo
	and c.cd_protocolo_externo = cd_protocolo_externo_p
	and d.nr_seq_protocolo = c.nr_sequencia
	and d.cd_campo_externo = cd_campo_externo_p
	and coalesce(b.dt_cancelamento::text, '') = ''
	and coalesce(b.dt_suspensao::text, '') = ''
	and (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

	if (nr_seq_rxt_tratamento_w IS NOT NULL AND nr_seq_rxt_tratamento_w::text <> '') then

		select max(a.nr_sequencia),
		max(obter_cod_medico_rxt_tumor(a.nr_seq_tratamento, a.nr_sequencia)),
		max(a.nr_seq_fase)
		into STRICT nr_seq_rxt_agenda_w,
		cd_medico_rxt_tumor_w,
		nr_seq_fase_w
		from rxt_agenda a,
		rxt_tratamento b
		where a.nr_seq_tratamento = b.nr_sequencia
		and b.nr_sequencia = nr_seq_rxt_tratamento_w
		and a.ie_status_agenda in ('A','M','T','V','AP')
		and to_date(to_char(a.dt_agenda, 'DD/MM/YY'),'DD/MM/YY' ) = to_date(dt_agenda_p, 'DD/MM/YY');

		if (nr_seq_rxt_agenda_w IS NOT NULL AND nr_seq_rxt_agenda_w::text <> '') then

			select max(a.nr_sequencia)
			into STRICT rxt_campo_nr_sequencia_w
			from rxt_campo a,
			rxt_fase_tratamento b,
			rxt_tratamento c,
			rxt_campo_protocolo d
			where a.nr_seq_fase = b.nr_sequencia
			and b.nr_seq_tratamento = c.nr_sequencia
			and c.nr_sequencia  = nr_seq_rxt_tratamento_w
			and a.nr_seq_campo = d.nr_sequencia
			and rxt_obter_se_campo_aplic(nr_seq_rxt_agenda_w, a.nr_sequencia, 'F') <> 'S'
			and d.cd_campo_externo = cd_campo_externo_p
			and b.nr_sequencia = nr_seq_fase_w;

			if (nr_seq_rxt_agenda_w IS NOT NULL AND nr_seq_rxt_agenda_w::text <> '' AND rxt_campo_nr_sequencia_w IS NOT NULL AND rxt_campo_nr_sequencia_w::text <> '') then

				CALL rxt_gerar_aplic_campo(
				nr_seq_rxt_agenda_w,
				rxt_campo_nr_sequencia_w,
				'A',
				qt_dose_p,
				null,
				cd_medico_rxt_tumor_w,
				nr_seq_fase_w,
				'F',
				'VARIAN'
				);

			end if;
		end if;
	end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rxt_gerar_aplic_campo_oru (cd_pessoa_fisica_p text, cd_protocolo_externo_p text, cd_campo_externo_p text, dt_agenda_p timestamp, qt_dose_p text ) FROM PUBLIC;

