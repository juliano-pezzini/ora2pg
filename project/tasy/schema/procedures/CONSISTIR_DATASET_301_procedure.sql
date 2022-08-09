-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_dataset_301 (nr_seq_estrut_arq_p bigint, nr_seq_dataset_p bigint, ie_dataset_p text, nm_usuario_p text) AS $body$
DECLARE


qt_rec_segmento_w	bigint;
qt_erro_w		bigint;
qt_alerta_w		bigint;
nr_seq_estrut_arq_w	bigint;

c01 CURSOR FOR
/*select	ie_elemento ie_segmento,
	ie_obrigatorio
from	table(RCM301_ARQUIVO_PCK.GET_SEGMENTOS_DATASET(ie_dataset_p))
order by nr_ordem;*/
SELECT	nr_sequencia,
	ie_segmento,
	ie_obrigatorio
from	C301_ESTRUTURA_SEG_DATASET
where	nr_seq_estrut_arq	= nr_seq_estrut_arq_p
and	ie_dataset		= ie_dataset_p;

c01_w	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	qt_rec_segmento_w := Obter_valor_Dinamico(	'SELECT COUNT(*) QT FROM D301_SEGMENTO_'|| c01_w.ie_segmento ||
				' WHERE NR_SEQ_DATASET = '|| nr_seq_dataset_p, qt_rec_segmento_w);

	if	(c01_w.ie_obrigatorio = 'S' AND qt_rec_segmento_w = 0) then
		--O segmento #@IE_SEGMENTO#@ é obrigatório para este dataset.
		CALL GERAR_D301_DATASET_INCONSIST(	nr_seq_dataset_p,
						'E',
						wheb_mensagem_pck.GET_TEXTO(996261,'IE_SEGMENTO='||c01_w.ie_segmento||';'),
						nm_usuario_p,
						c01_w.ie_segmento);
	end if;

	if (qt_rec_segmento_w > 0) then
		CALL CONSISTIR_SEGMENTO_301(c01_w.nr_sequencia,nr_seq_dataset_p,c01_w.ie_segmento,nm_usuario_p);
	end if;

end loop;
close C01;

begin
select	1
into STRICT	qt_erro_w
from	d301_dataset_inconsist
where	nr_seq_dataset	= nr_seq_dataset_p
and	ie_tipo	= 'E'  LIMIT 1;
exception
when others then
	qt_erro_w := 0;
end;

begin
select	1
into STRICT	qt_alerta_w
from	d301_dataset_inconsist
where	nr_seq_dataset	= nr_seq_dataset_p
and	ie_tipo	= 'A'  LIMIT 1;
exception
when others then
	qt_alerta_w := 0;
end;

if (qt_erro_w > 0) then

	update	d301_dataset_envio
	set	ie_status_validacao 	= 'E'
	where	nr_sequencia		= nr_seq_dataset_p;

elsif (qt_alerta_w > 0) then
	update	d301_dataset_envio
	set	ie_status_validacao 	= 'A'
	where	nr_sequencia		= nr_seq_dataset_p;
else
	update	d301_dataset_envio
	set	ie_status_validacao 	= 'V',
		ie_status_envio		= 'P'
	where	nr_sequencia		= nr_seq_dataset_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_dataset_301 (nr_seq_estrut_arq_p bigint, nr_seq_dataset_p bigint, ie_dataset_p text, nm_usuario_p text) FROM PUBLIC;
