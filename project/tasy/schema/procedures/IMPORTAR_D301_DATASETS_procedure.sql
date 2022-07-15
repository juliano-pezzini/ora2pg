-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_d301_datasets ( nr_seq_arq_conteudo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conteudo_w			text;
ds_conteudo_dataset_w		text;
ds_conteudo_segmento_w		varchar(2000);
nr_pos_ini_dataset_w		bigint;
nr_pos_fim_dataset_w		bigint;
nr_pos_aspa_pos_unt_w		bigint;
nr_seq_arquivo_retorno_w	d301_arquivo_retorno.nr_sequencia%type;
nr_seq_dataset_w		d301_dataset_retorno.nr_sequencia%type;
ie_dataset_w			varchar(4);
qt_repet_w			integer	:= 1;
qt_repet2_w			integer	:= 1;


BEGIN
select	regexp_replace(regexp_replace(ds_conteudo,chr(13),null),chr(10),null),
	nr_seq_arquivo_retorno
into STRICT	ds_conteudo_w,
	nr_seq_arquivo_retorno_w
from	d301_arquivo_conteudo a
where	a.nr_sequencia	= nr_seq_arq_conteudo_p;

/* Search for dataset*/

select	dbms_lob.position('UNH+' in ds_conteudo_w)
into STRICT	nr_pos_ini_dataset_w
;

/* END of dataset */

select	dbms_lob.position('UNT+' in ds_conteudo_w)
into STRICT	nr_pos_fim_dataset_w
;

nr_pos_aspa_pos_unt_w	:= dbms_lob.position(chr(39) in substr(ds_conteudo_w,100,dbms_lob.position('UNT+' in ds_conteudo_w)));

nr_pos_fim_dataset_w	:= nr_pos_fim_dataset_w + nr_pos_aspa_pos_unt_w;

/* Get end ofof UNT*/

nr_pos_fim_dataset_w	:= nr_pos_fim_dataset_w;

while	(nr_pos_ini_dataset_w >=0 AND nr_pos_fim_dataset_w >=0) loop

	ds_conteudo_dataset_w	:= substr(ds_conteudo_w,nr_pos_fim_dataset_w - nr_pos_ini_dataset_w,nr_pos_ini_dataset_w);
	ds_conteudo_w		:= substr(ds_conteudo_w,octet_length(ds_conteudo_w),nr_pos_fim_dataset_w);

	/* Search for dataset*/

	select	dbms_lob.position('UNH+' in ds_conteudo_w)
	into STRICT	nr_pos_ini_dataset_w
	;

	select	dbms_lob.position('UNT+' in ds_conteudo_w)
	into STRICT	nr_pos_fim_dataset_w
	;

	/* Get end of UNT*/

	nr_pos_aspa_pos_unt_w	:= dbms_lob.position(chr(39) in substr(ds_conteudo_w,100,dbms_lob.position('UNT+' in ds_conteudo_w)));

	nr_pos_fim_dataset_w	:= nr_pos_fim_dataset_w + nr_pos_aspa_pos_unt_w;

	ie_dataset_w	:= null;
	if (dbms_lob.position('+ANFM:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'ANFM';
	elsif (dbms_lob.position('+KOUB:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'KOUB';
	elsif (dbms_lob.position('+KAIN:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'KAIN';
	elsif (dbms_lob.position('+ZAHL:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'ZAHL';
	elsif (dbms_lob.position('+ZAAO:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'ZAAO';
	elsif (dbms_lob.position('+SAMU:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'SAMU';
	elsif (dbms_lob.position('+PKOS:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'PKOS';
	elsif (dbms_lob.position('+PZAH:' in ds_conteudo_dataset_w) > 0) then
		ie_dataset_w	:= 'PZAH';
	end if;

	if (ie_dataset_w IS NOT NULL AND ie_dataset_w::text <> '') then
		select	nextval('d301_dataset_retorno_seq')
		into STRICT	nr_seq_dataset_w
		;

		insert into d301_dataset_retorno(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_arquivo,
			ie_dataset,
			nr_ordem)
		values (nr_seq_dataset_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_seq_arquivo_retorno_w,
			ie_dataset_w,
			qt_repet_w);

		ds_conteudo_segmento_w	:= substr(ds_conteudo_dataset_w,dbms_lob.position(chr(39) in ds_conteudo_dataset_w) - 1,1);
		ds_conteudo_dataset_w	:= substr(ds_conteudo_dataset_w,2000,dbms_lob.position(chr(39) in ds_conteudo_dataset_w) + 1);
		qt_repet2_w	:= 1;

		while(ds_conteudo_segmento_w IS NOT NULL AND ds_conteudo_segmento_w::text <> '') loop

			CALL importar_d301_segmento_UNH(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			if (ie_dataset_w = 'ANFM') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_INV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_TXT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			elsif (ie_dataset_w = 'KOUB') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_INV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_CUX(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_KOS(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_TXT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			elsif (ie_dataset_w = 'KAIN') then
				null;
			elsif (ie_dataset_w = 'ZAHL') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_INV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_CUX(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);

				CALL importar_d301_segmento_REC(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ZLG(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ZPR(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ENT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			elsif (ie_dataset_w = 'ZAAO') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_INV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_CUX(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);

				CALL importar_d301_segmento_REC(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ZLG(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ZPR(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ENA(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_EZV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			elsif (ie_dataset_w = 'SAMU') then
				null;
			elsif (ie_dataset_w = 'PKOS') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_PNV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_CUX(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_KOS(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_TXT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_PVK(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			elsif (ie_dataset_w = 'PZAH') then
				CALL importar_d301_segmento_FKT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_PNV(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_NAD(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_CUX(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_REC(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ZPR(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
				CALL importar_d301_segmento_ENT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);
			end if;
			CALL importar_d301_segmento_UNT(nr_seq_dataset_w,ds_conteudo_segmento_w,nm_usuario_p);

			ds_conteudo_segmento_w	:= substr(ds_conteudo_dataset_w,dbms_lob.position(chr(39) in ds_conteudo_dataset_w),1);
			ds_conteudo_dataset_w	:= substr(ds_conteudo_dataset_w,2000,dbms_lob.position(chr(39) in ds_conteudo_dataset_w) + 1);

			qt_repet2_w	:= qt_repet2_w + 1;

			/* infinite loop breaker */

			if (qt_repet2_w = 9999) then
				exit;
			end if;
		end loop;

		/* Update Tasy tables */

		if (ie_dataset_w = 'ANFM') then
			CALL CARREGAR_301_JUST_MEDICA(nr_seq_dataset_w,nm_usuario_p);
		end if;
	end if;

	qt_repet_w	:= qt_repet_w + 1;

	/* infinite loop breaker */

	if (qt_repet_w = 9999) then
		exit;
	end if;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_d301_datasets ( nr_seq_arq_conteudo_p bigint, nm_usuario_p text) FROM PUBLIC;

