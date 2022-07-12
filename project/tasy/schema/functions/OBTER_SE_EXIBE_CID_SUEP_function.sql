-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_cid_suep ( nr_atendimento_p bigint, cd_doenca_p text, dt_diagnostico_p timestamp, nr_seq_suep_p bigint, ie_grupo_p text default null, ie_classif_diag_p text default null, ie_tipo_diagnostico_p bigint default null, ie_html_p text default null) RETURNS varchar AS $body$
DECLARE


ie_apresenta_w			varchar(1);
ie_tipo_diagnostico_w	smallint;
ie_classif_diag_w		varchar(20);

C01 CURSOR FOR
	SELECT 	ie_tipo_diagnostico,
		ie_classificacao_doenca
	from   	suep a,
		suep_grupo b,
		item_suep c,
		informacao_suep d
	where  	a.nr_sequencia = b.nr_seq_suep
	and	c.nr_seq_grupo = b.nr_sequencia
	and	d.nr_seq_item = c.nr_sequencia
	and	a.nr_sequencia = nr_seq_suep_p
	and	c.ie_tipo_item = 'CD';

C02 CURSOR FOR
	SELECT 	a.nr_sequencia
	from   	suep a,
		item_suep c,
		informacao_suep d
	where  	a.nr_sequencia = c.nr_seq_suep
	and	d.nr_seq_item = c.nr_sequencia
	and	a.nr_sequencia = nr_seq_suep_p
	and	c.ie_tipo_item = 'CD'
	and	coalesce(d.ie_tipo_diagnostico,ie_tipo_diagnostico_w) = ie_tipo_diagnostico_w
	and	coalesce(d.ie_classificacao_doenca,ie_classif_diag_w) = coalesce(ie_classif_diag_p,ie_classif_diag_w);


C03 CURSOR FOR
	SELECT 	ie_tipo_diagnostico,
			ie_classificacao_doenca
	from   	suep a,
			item_suep c,
			informacao_suep d
	where  	a.nr_sequencia = c.nr_seq_suep
	and		d.nr_seq_item = c.nr_sequencia
	and		a.nr_sequencia = nr_seq_suep_p
	and		c.ie_tipo_item = 'CD';

BEGIN


if (coalesce(ie_html_p,'N')	= 'S') then

	SELECT  coalesce(max('N'),'S')
	INTO STRICT	ie_apresenta_w
	FROM   	suep a,
			item_suep c,
			informacao_suep d
	WHERE  	a.nr_sequencia = c.nr_seq_suep
	AND		d.nr_seq_item = c.nr_sequencia
	AND		a.nr_sequencia = nr_seq_suep_p
	AND		c.ie_tipo_item = 'CD';

	if (ie_apresenta_w = 'N')then

		open C03;
		loop
		fetch C03 into
			ie_tipo_diagnostico_w,
			ie_classif_diag_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

				select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_apresenta_w
				from	diagnostico_doenca a
				where	a.nr_atendimento = nr_atendimento_p
				and	a.cd_doenca = cd_doenca_p
				and	a.dt_diagnostico = dt_diagnostico_p
				and	((a.ie_classificacao_doenca 	= ie_classif_diag_w) or (coalesce(ie_classif_diag_w::text, '') = ''))
				and	((a.ie_tipo_diagnostico		= ie_tipo_diagnostico_w) or (coalesce(ie_tipo_diagnostico_w::text, '') = ''));

				if (ie_apresenta_w = 'S') then
					exit;
				end if;

			end;
		end loop;
		close C03;
	end if;


elsif (coalesce(ie_grupo_p,'S')	= 'S') then

	open C01;
	loop
	fetch C01 into
		ie_tipo_diagnostico_w,
		ie_classif_diag_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_apresenta_w
			from	diagnostico_doenca a
			where	a.nr_atendimento = nr_atendimento_p
			and	a.cd_doenca = cd_doenca_p
			and	a.dt_diagnostico = dt_diagnostico_p
			and	((a.ie_classificacao_doenca 	= ie_classif_diag_w) or (coalesce(ie_classif_diag_w::text, '') = ''))
			and	((a.ie_tipo_diagnostico		= ie_tipo_diagnostico_w) or (coalesce(ie_tipo_diagnostico_w::text, '') = ''));

			if (ie_apresenta_w = 'S') then
				exit;
			end if;

		end;
	end loop;
	close C01;


else
	ie_tipo_diagnostico_w	:= coalesce(ie_tipo_diagnostico_p,-1);
	ie_classif_diag_w	:= coalesce(ie_classif_diag_p,'XPTO');
	ie_apresenta_w	:= 'N';
	for r_c02 in c02 loop
		begin
		ie_apresenta_w	:= 'S';
		end;
	end loop;

end if;


return	ie_apresenta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_cid_suep ( nr_atendimento_p bigint, cd_doenca_p text, dt_diagnostico_p timestamp, nr_seq_suep_p bigint, ie_grupo_p text default null, ie_classif_diag_p text default null, ie_tipo_diagnostico_p bigint default null, ie_html_p text default null) FROM PUBLIC;
