-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_taxa_aih (nr_interno_conta_p bigint) AS $body$
DECLARE


cd_procedimento_w	bigint;
nr_sequencia_w		bigint;
vl_matmed_w		double precision;
nr_ordem_w		smallint;
ie_ordem_w		smallint;
tx_procedimento_w	double precision;
tx_proc_ler_w		double precision;
nr_seq_w		smallint;
nr_laudo_sus_w		smallint;

C01 CURSOR FOR
	SELECT 	CASE WHEN cd_procedimento=39000001 THEN 1 WHEN cd_procedimento=31000002 THEN 2 WHEN cd_procedimento=70000000 THEN 3 WHEN cd_procedimento=40290000 THEN 4 WHEN cd_procedimento=33000000 THEN 5  ELSE 9 END ,
			a.cd_procedimento,
			a.nr_sequencia,
			a.tx_procedimento,
			/*0 nr_laudo_sus, Felipe - 12/10/2006 Comentei pois pode existir mais de um procedimento de mesmo código nos autorizados*/

			0 vl_matmed
	from		Procedimento_paciente a
	where		a.nr_interno_conta	= nr_interno_conta_p
	and		a.cd_procedimento		in (39000001, 31000002,70000000,40290000,33000000)
	
union

	SELECT 	9,
			a.cd_procedimento,
			a.nr_sequencia,
			a.tx_procedimento,
			/*c.nr_laudo_sus,*/

			b.vl_matmed
	from		Procedimento_paciente a,
			sus_valor_proc_paciente b,
			sus_laudo_paciente c
	where		a.nr_sequencia		= b.nr_sequencia
	and		a.nr_interno_conta	= nr_interno_conta_p
	and		a.nr_atendimento		= c.nr_atendimento
	and 		a.cd_procedimento		= c.cd_procedimento_solic
	and		a.cd_procedimento	not in (39000001,31000002,70000000,40290000,33000000)
	and (substr(a.cd_procedimento,1,5) <> '76400')
	and		((a.cd_procedimento between 31000000 and 49999999) or (a.cd_procedimento between 69000000 and 91999999))
	order by	1, 5 desc, 3;


BEGIN
ie_ordem_w	:= 0;
nr_seq_w	:= 0;

OPEN C01;
LOOP
FETCH C01 into
		nr_ordem_w,
		cd_procedimento_w,
		nr_sequencia_w,
		tx_proc_ler_w,
		/*nr_laudo_sus_w,*/

		vl_matmed_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	tx_procedimento_w 	:= 100;
	if (nr_ordem_w	< 9) then
		ie_ordem_w			:= nr_ordem_w;
	else
		begin
		nr_seq_w	:= nr_seq_w + 1;
		if (ie_ordem_w = 1) then
			if (nr_seq_w	= 1) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 2) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 3) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 4) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 5) then
				tx_procedimento_w := 50;
			end if;
		end if;

		if (ie_ordem_w = 2) then
			if (nr_seq_w	= 1) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 2) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 3) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 4) then
				tx_procedimento_w := 60;
			elsif (nr_seq_w	= 5) then
				tx_procedimento_w := 50;
			end if;
		end if;

		if (ie_ordem_w = 3) then
			if (nr_seq_w	= 1) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 2) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 3) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 4) then
				tx_procedimento_w := 75;
			end if;
		end if;


		if (ie_ordem_w = 4) then
			if (nr_seq_w	= 1) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 2) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 3) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 4) then
				tx_procedimento_w := 50;
			elsif (nr_seq_w	= 5) then
				tx_procedimento_w := 50;
			end if;
		end if;


		if (ie_ordem_w = 5) then
			if (nr_seq_w	= 1) then
				tx_procedimento_w := 100;
			elsif (nr_seq_w	= 2) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 3) then
				tx_procedimento_w := 75;
			elsif (nr_seq_w	= 4) then
				tx_procedimento_w := 60;
			elsif (nr_seq_w	= 5) then
				tx_procedimento_w := 50;
			end if;
		end if;

		if (tx_procedimento_w <> tx_proc_ler_w) then
			update	Procedimento_paciente
			set		tx_procedimento 	= tx_procedimento_w
			where		nr_sequencia	= nr_sequencia_w;
		end if;
		end;
	end if;
	end;
END LOOP;
CLOSE C01;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_taxa_aih (nr_interno_conta_p bigint) FROM PUBLIC;

