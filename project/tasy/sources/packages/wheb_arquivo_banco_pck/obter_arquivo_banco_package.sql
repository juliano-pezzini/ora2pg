-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_arquivo_banco_pck.obter_arquivo_banco ( nm_tabela_p text, nr_sequencia_p bigint, nm_arquivo_p text) AS $body$
DECLARE


	vblob		bytea;
	vstart		bigint := 1;
	bytelen		bigint := 32000;
	tamanho		bigint;
	my_vr		bytea;
	x		bigint;
	l_output	utl_file.file_type;

	
BEGIN
	if ((trim(both nm_tabela_p) IS NOT NULL AND (trim(both nm_tabela_p))::text <> '')) then
		if (nm_tabela_p = 'PESSOA_DOCUMENTACAO') then
			-- select blob into variable
			select	count(1)
			into STRICT	x
			from	arquivo_tasy
			where	nr_seq_pessoa_documentacao = nr_sequencia_p;

			if (x > 0) then
				select	ds_conteudo_arquivo
				into STRICT	vblob
				from	arquivo_tasy
				where	nr_seq_pessoa_documentacao = nr_sequencia_p;
			end if;
		end if;

		-- get length of blob
		tamanho := octet_length(vblob);

		if (tamanho > 0) then
			-- save blob length
			x := tamanho;

			-- define output directory
			l_output := utl_file.fopen('ARQUIVOS_TASY', nm_arquivo_p,'WB'/*, 32760*/
);

			vstart := 1;
			bytelen := 32000;

			-- if small enough for a single write
			IF tamanho < 32760 THEN
				utl_file.put_raw(l_output,vblob);
				utl_file.fflush(l_output);
			ELSE -- write in pieces
				vstart := 1;

				WHILE vstart < tamanho and bytelen > 0 LOOP
				   dbms_lob.read(vblob,bytelen,vstart,my_vr);

				   utl_file.put_raw(l_output,my_vr);
				   utl_file.fflush(l_output);

				   -- set the start position for the next cut
				   vstart := vstart + bytelen;

				   -- set the end position if less than 32000 bytes
				   x := x - bytelen;
				   IF x < 32000 THEN
				      bytelen := x;
				   END IF;
				END loop;
			end if;
			utl_file.fclose(l_output);
		end if;
	end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_arquivo_banco_pck.obter_arquivo_banco ( nm_tabela_p text, nr_sequencia_p bigint, nm_arquivo_p text) FROM PUBLIC;
