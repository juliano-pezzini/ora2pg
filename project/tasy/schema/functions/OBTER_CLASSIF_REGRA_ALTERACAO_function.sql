-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_regra_alteracao (cd_tipo_agenda_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, ie_classif_ant_p text) RETURNS varchar AS $body$
DECLARE


ds_classif_w		varchar(10);
nr_seq_classif_nova_w	alteracao_classif_agenda.nr_seq_classif_nova%type;
cd_estab_agenda_w	estabelecimento.cd_estabelecimento%type;
qt_reg_w		smallint;

procedure obter_dados_agenda is
	;
BEGIN
	select 	max(cd_estabelecimento)
	into STRICT	cd_estab_agenda_w
	from 	agenda
	where 	cd_agenda = cd_agenda_p;
	end;

begin
if (ie_classif_ant_p IS NOT NULL AND ie_classif_ant_p::text <> '') and ((cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') or (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '')) and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (ie_classif_ant_p IS NOT NULL AND ie_classif_ant_p::text <> '') then
	if (cd_tipo_agenda_p in (3,4,5)) then
		select 	coalesce(max(1),0)
		into STRICT	qt_reg_w
		from 	alteracao_classif_agenda
		where 	ie_situacao = 'A'
		and 	ie_classif_ant = ie_classif_ant_p
		and		(nr_tempo_alteracao IS NOT NULL AND nr_tempo_alteracao::text <> '');
		if (qt_reg_w > 0) then
			PERFORM obter_dados_agenda();
			select 	max(ie_classif)
			into STRICT	ds_classif_w
			from	(SELECT coalesce(ie_classif_nova, ie_classif_ant_p) ie_classif
				from 	alteracao_classif_agenda
				where 	ie_classif_ant = ie_classif_ant_p
				and 	((cd_agenda = cd_agenda_p) or (cd_tipo_agenda = cd_tipo_agenda_p and coalesce(cd_agenda::text, '') = ''))
				and 	ie_situacao = 'A'
				and 	dt_agenda_p between coalesce(dt_inicio_vigencia, dt_agenda_p) and coalesce(dt_fim_vigencia, dt_agenda_p)
				and	dt_agenda_p between clock_timestamp() and clock_timestamp()+nr_tempo_alteracao/24/60
				and	coalesce(cd_estabelecimento,cd_estab_agenda_w) = cd_estab_agenda_w
				order by coalesce(cd_agenda,0) desc, coalesce(cd_tipo_agenda,0) desc, ie_classif_ant desc ) alias13 LIMIT 1;
		end if;
	elsif (cd_tipo_agenda_p = 2) then
		select 	coalesce(max(1),0)
		into STRICT	qt_reg_w
		from 	alteracao_classif_agenda
		where 	ie_situacao = 'A'
		and	nr_seq_classif_ant = (ie_classif_ant_p)::numeric
		and		(nr_tempo_alteracao IS NOT NULL AND nr_tempo_alteracao::text <> '');
		if (qt_reg_w > 0) then
			PERFORM obter_dados_agenda();
			select 	max(nr_seq_classif_nova)
			into STRICT 	nr_seq_classif_nova_w
			from	(SELECT nr_seq_classif_nova
				from 	alteracao_classif_agenda
				where 	nr_seq_classif_ant = (ie_classif_ant_p)::numeric
				and 	((cd_agenda = cd_agenda_p) or (cd_tipo_agenda = cd_tipo_agenda_p and coalesce(cd_agenda::text, '') = ''))
				and 	ie_situacao = 'A'
				and 	dt_agenda_p between coalesce(dt_inicio_vigencia, dt_agenda_p) and coalesce(dt_fim_vigencia, dt_agenda_p)
				and	dt_agenda_p between clock_timestamp() and clock_timestamp()+nr_tempo_alteracao/24/60
				and	coalesce(cd_estabelecimento,cd_estab_agenda_w) = cd_estab_agenda_w
				order by coalesce(cd_agenda,0) desc, coalesce(cd_tipo_agenda,0) desc, nr_seq_classif_ant desc) alias13 LIMIT 1;
			if (nr_seq_classif_nova_w IS NOT NULL AND nr_seq_classif_nova_w::text <> '') then
				ds_classif_w := to_char(nr_seq_classif_nova_w);
			else
				ds_classif_w := ie_classif_ant_p;
			end if;
		end if;
	end if;
end if;

return	coalesce(ds_classif_w, ie_classif_ant_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_regra_alteracao (cd_tipo_agenda_p bigint, cd_agenda_p bigint, dt_agenda_p timestamp, ie_classif_ant_p text) FROM PUBLIC;

