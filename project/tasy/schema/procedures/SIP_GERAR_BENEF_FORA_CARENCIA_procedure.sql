-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_gerar_benef_fora_carencia ( nr_seq_lote_sip_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_periodo_inicial_w		timestamp;
qt_beneficiario_w		bigint;
ie_tipo_contratacao_w		varchar(2);
ie_segmentacao_w		varchar(3);
ie_segmentacao_hosp_obs_w	varchar(3);
ie_segmentacao_hosp_w		varchar(3);
ie_segmentacao_odont_w		varchar(3);
ie_segmentacao_ww		varchar(3);

C01 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_consulta_medica		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C02 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_consulta_ambulatorial	< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C03 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_consulta_pronto_soc		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C04 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_outro_atend_amb		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C05 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_exame			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C06 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_proced_diagnostico		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C07 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_mamografia			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C08 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_sangue_oculto		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C09 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_terapia			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C10 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_internacao			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C11 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_fratura_femur		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C12 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_doenca_respiratoria		< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C13 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_hospitalar			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C14 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_hospital_dia			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;

C15 CURSOR FOR
	SELECT	count(*),
		ie_tipo_contratacao,
		ie_segmentacao
	from	sip_beneficiario_exposto
	where	dt_domiciliar			< dt_periodo_inicial_w
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	coalesce(dt_rescisao::text, '') = ''
	and	((coalesce(ie_tipo_segurado,'B') 	= 'B')
	or (coalesce(ie_tipo_segurado,'B') 	= 'R'))
	group by ie_tipo_contratacao,
		 ie_segmentacao;


BEGIN

update	sip_lote_item_assistencial
set	qt_beneficiario		= 0
where	nr_seq_lote		= nr_seq_lote_sip_p;

select	dt_periodo_inicial
into STRICT	dt_periodo_inicial_w
from	pls_lote_sip
where	nr_sequencia	= nr_seq_lote_sip_p;

open C01;
loop
fetch C01 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;


	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'A'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C01;


open C02;
loop
fetch C02 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'A1'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'A2'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C03;


open C04;
loop
fetch C04 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin
	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'B'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C04;

open C05;
loop
fetch C05 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'C'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C05;

open C06;
loop
fetch C06 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C06 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'C3'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C06;

open C07;
loop
fetch C07 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C07 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'C10.1'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C07;

open C08;
loop
fetch C08 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C08 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'C14'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C08;

open C09;
loop
fetch C09 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C09 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'D'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C09;

open C10;
loop
fetch C10 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C10 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'E'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C10;

open C11;
loop
fetch C11 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C11 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'EX2.4'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C11;

open C12;
loop
fetch C12 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C12 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'EX4.1'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C12;

open C13;
loop
fetch C13 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C13 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'EY1'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C13;

open C14;
loop
fetch C14 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C14 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;


	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'EY2'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C14;

open C15;
loop
fetch C15 into
	qt_beneficiario_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w;
EXIT WHEN NOT FOUND; /* apply on C15 */
	begin

	ie_segmentacao_odont_w		:= 0;
 	ie_segmentacao_ww		:= 0;
	ie_segmentacao_hosp_w		:= 0;
	ie_segmentacao_hosp_obs_w	:= 0;

	if (ie_segmentacao_w in ('1','5','6','7','8','11','12')) then
		ie_segmentacao_ww	:= 1;
	end if;

	if (ie_segmentacao_w in ('3','7','10','12')) then
		ie_segmentacao_hosp_w	:= 3;
	end if;

	if (ie_segmentacao_w in ('2','5','6','9','11')) then
		ie_segmentacao_hosp_obs_w	:= 3;
	end if;

	if (ie_segmentacao_w = '4') then
		ie_segmentacao_odont_w	:= 4;
	end if;

	update	sip_lote_item_assistencial
	set	qt_beneficiario		= qt_beneficiario + qt_beneficiario_w
	where	cd_classificacao_sip	= 'EY3'
	and	nr_seq_lote		= nr_seq_lote_sip_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_w
	and	ie_segmentacao_sip	in (ie_segmentacao_ww,ie_segmentacao_hosp_w,ie_segmentacao_hosp_obs_w,ie_segmentacao_odont_w);
	end;
end loop;
close C15;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_gerar_benef_fora_carencia ( nr_seq_lote_sip_p bigint, nm_usuario_p text) FROM PUBLIC;

